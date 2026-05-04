{ config, pkgs, lib, powerProfile, ... }:

{
  imports =
    [ 
      ./system/hardware-configuration.nix
      ./system/user.nix
      ./system/boot.nix
    ];

  config = lib.mkMerge [
    {
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
    }

    (lib.mkIf (powerProfile == "eco") {
      powerManagement.powertop.enable = true;
      powerManagement.powertop.postStart = ''
        ${pkgs.systemd}/bin/udevadm trigger -c bind -s usb -a idVendor=2717 -a idProduct=5013
      '';

      services.udev.extraRules = ''
        ACTION=="add|bind", SUBSYSTEM=="usb", ATTR{idVendor}=="2717", ATTR{idProduct}=="5013", ATTR{power/control}="on"
      '';
    })
  ];
}


