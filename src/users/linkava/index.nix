{
  pkgs,
  inputs,
  config,
  ...
}:

let
  programmingTools = with pkgs; [
    podman-compose
    lazygit
    gh
    nodejs
    codex
    pnpm
    lsd
    arduino-ide
    nixfmt
    jetbrains-toolbox
    helix
    nixd
    powertop
    glow
    zip
    distrobox
    platformio
    nmap
    yt-dlp
    clang-tools
    arduino-cli
    iw
  ];

  systemTools = with pkgs; [
    cliphist
    wl-clipboard
    wtype
    rofi
    rofi-rbw
    gamescope
    btop
    zathura
    kdePackages.dolphin
  ];

  flakes = [
    inputs.nixvim.homeModules.nixvim
    inputs.noctalia.homeModules.default
  ];
in
{
  imports = [
    ./desktop-environment.nix
  ]
  ++ flakes;

  xdg.configFile."niri/config.kdl".force = true;

  home = {
    username = "linkava";
    homeDirectory = "/home/linkava";
    stateVersion = "25.11";

    packages =
      (with pkgs; [
        anki-bin
        chromium
        libreoffice-qt
        obsidian
        foliate
        localsend
        affine
        qbittorrent
        vlc
        tor-browser
        inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher
      ])
      ++ programmingTools
      ++ systemTools;
  };

  services = {
    cliphist.enable = true;
  };

  programs = {
    nixvim = import ./programs/nvim.nix { inherit config pkgs; };
    vscode = import ./programs/vscode.nix { inherit pkgs; };
    ssh = import ./programs/ssh.nix;
    zsh = import ./programs/zsh.nix;

    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };

    rbw = {
      enable = true;

      settings = {
        email = "const.time.flow@gmail.com";
        pinentry = pkgs.pinentry-gnome3;
      };
    };

    ghostty = {
      enable = true;
      settings = {
        theme = "TokyoNight";
        cursor-style = "bar";
      };
    };

    git = {
      enable = true;

      settings = {
        user.name = "DanFromUkraine";
        user.email = "ovsannikovdana91@gmail.com";
      };
    };

    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };

    nh = {
      enable = true;

      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };

      flake = "/home/linkava/nixos-config";
    };

    home-manager.enable = true;
  };
}
