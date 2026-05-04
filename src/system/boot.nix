{ config, pkgs, lib, powerProfile, ... }:

let
  customKernel = pkgs.linux_latest.override {
    structuredExtraConfig = with lib.kernel; {
      SCHED_CLASS_EXT = yes;
      BPF_SYSCALL = yes;
    };
  };

  optimizedKernel = customKernel.overrideAttrs (finalAttrs: previousAttrs: {
    makeFlags = (previousAttrs.makeFlags or [ ]) ++ [ "KCFLAGS=-march=znver5" ];
  });
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackagesFor optimizedKernel;
  
  boot.kernelParams = [ "amd_pstate=active" ];

  services.scx.enable = true;
  
  services.scx.scheduler = if powerProfile == "performance" 
    then "scx_lavd" 
    else "scx_bpfland";

  services.scx.extraArgs = if powerProfile == "performance" 
    then [ "--autopower" ] 
    else[ "--powersave" ];
}