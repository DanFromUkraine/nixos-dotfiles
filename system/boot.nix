{ pkgs }: {
  kernelPackages = pkgs.linuxPackages_latest;
  loader.systemd-boot.enable = true;
  loader.efi.canTouchEfiVariables = true;
  kernelParams = [ "amd_pstate=active" ];
}
