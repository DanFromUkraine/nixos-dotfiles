{ pkgs, ... }:

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
    iftop
    anki-bin
    chromium
    jetbrains-toolbox
    helix
    nixd
    powertop
    libreoffice-qt
    obsidian
    foliate
    tor-browser
    nodejs
    codex
    pnpm
    lsd
    arduino-ide
    zed-editor
    nixfmt
    keepassxc
    cliphist
    wl-clipboard
    fuzzel
  ];

  services.cliphist.enable = true;

  programs = {

    vscode = {
      enable = true;

      package = pkgs.vscode.fhsWithPackages (
        ps: with ps; [
          python3
          platformio-core
          gcc
        ]
      );

      extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        platformio.platformio-vscode-ide
        jnoortheen.nix-ide
        ms-vscode-remote.remote-containers
      ];
    };

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

    ssh = {
      enable = true;

      extraConfig = ''
        Host gitlab.com
          HostName gitlab.com
          User git
          IdentityFile ~/nixos-config/src/secrets/gitlab/gitlab
          IdentitiesOnly yes

        Host github.com
          HostName github.com
          User git
          IdentityFile ~/nixos-config/src/secrets/github/github
          IdentitiesOnly yes
      '';
    };

    home-manager.enable = true;

    fuzzel = {
      enable = true;
      settings = {
        main = {
          prompt = "📋 ";
          lines = 10;
          width = 40;
          horizontal-pad = 20;
          vertical-pad = 20;
        };
        border.radius = 12;
        colors = {
          background = "1e1e2eff";
          text = "cdd6f4ff";
          match = "89b4faff";
          selection = "313244ff";
          selection-text = "cdd6f4ff";
          border = "89b4faff";
        };
      };
    };
  };
}
