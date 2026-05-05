{ config, pkgs, lib, powerProfile, ... }:

{
  imports =
    [ 
      ./system/hardware-configuration.nix
      ./system/user.nix
      ./system/boot.nix
    ];

      # Other
      system.stateVersion = "25.11";
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      nixpkgs.config.allowUnfree = true;
      hardware.bluetooth.enable = true;

      # Network
      networking.hostName = "linkava";       
      networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
      networking.networkmanager.enable = true;

      # Desktop manager
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      services.desktopManager.plasma6.enable = true;

      # Audio specifics
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Optimizations

      zramSwap = {
        enable = true;
        priority = 90;
        algorithm = "zstd";
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
}


