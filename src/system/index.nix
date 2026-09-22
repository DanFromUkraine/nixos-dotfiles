{
  config,
  pkgs,
  lib,
  powerProfile,
  isGame,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];
  system.stateVersion = "25.11";

  users.users = import ./users.nix;
  boot = import ./boot.nix { inherit pkgs; };
  services = import ./services.nix { inherit powerProfile; };
  programs = import ./sys-programs.nix { inherit isGame; };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    asus.battery.chargeUpto = 70;
  };

  networking = {
    hostName = "linkava";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    networkmanager.enable = true;
  };

  zramSwap = {
    enable = true;
    priority = 90;
    algorithm = "zstd";
  };

  security = {
    rtkit.enable = true;
  };

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";
}
