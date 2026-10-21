{
  pkgs,
  powerProfile,
  isGame,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.noctalia.nixosModules.default
  ];
  system.stateVersion = "25.11";

  users.users = import ./users.nix { inherit pkgs; };
  boot = import ./boot.nix { inherit pkgs; };
  services = import ./services.nix { inherit powerProfile; };
  programs = import ./sys-programs.nix { inherit isGame pkgs; };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  virtualisation = {
    docker.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    asus.battery.chargeUpto = 70;
  };

  networking = {
    hostName = "linkava";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    networkmanager = {
      enable = true;
      wifi.powersave = powerProfile == "eco";
    };
  };

  zramSwap = {
    enable = true;
    priority = 90;
    algorithm = "zstd";
  };

  security = {
    rtkit.enable = true;
  };
}
