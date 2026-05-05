{ config, pkgs, lib, powerProfile, isGame, ... }:

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

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  boot.kernelParams = [ 
    "amd_pstate=active" 
    "amdgpu.abmlevel=${if powerProfile == "eco" then "4" else "0"}"
  ] ++ lib.optionals isGame [
    "amdgpu.dcdebugmask=0x600"
    "amdgpu.ttm_pages_limit=2097152"
    "ttm.pages_limit=2097152"
  ];

  services.scx.enable = true;
  
  services.scx.scheduler = if powerProfile == "performance" 
    then "scx_lavd" 
    else "scx_bpfland";

  services.scx.extraArgs = if powerProfile == "performance" 
    then [ "--autopower" ] 
    else [ "-m" "powersave" ];
}