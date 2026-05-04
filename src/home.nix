{ pkgs, powerProfile, ... }:

{
  home = {
    username = "linkava";
    homeDirectory = "/home/linkava";
    stateVersion = "25.11";
  };

  home.packages = with pkgs; [
    btop
    glow
    yazi
    zip
    gemini-cli
    iftop
    telegram-desktop
    vscode
    anki-bin
    chromium
    jetbrains.webstorm
    viber
    helix
    nixd
    powertop
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "DanFromUkraine";
        user.email = "ovsannikovdana91@gmail.com";
      };
    };

    firefox.enable = true;
    
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/linkava/nixos-config";
    };

    home-manager.enable = true;

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      
      matchBlocks = {
        "github.com" = {
          host = "github.com";
          user = "git";
          identityFile = "/home/linkava/nixos-config/src/secrets/github_key";
        };
      };
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true; 
      localNetworkGameTransfers.openFirewall = true;
    };
  }; 
}
