{
  pkgs,
  inputs,
  ...
}:

let
  basePackages = with pkgs; [
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
  ];

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
    yarn
    lazydocker
    bat
    jq
  ];

  systemTools = with pkgs; [
    brightnessctl
    playerctl
    wl-clipboard
    wtype
    rofi
    rofi-rbw
    gamescope
    btop
    zathura
    kdePackages.dolphin
    wiremix
    imagemagick
  ];
in
{
  environment.systemPackages = basePackages ++ programmingTools ++ systemTools;
}
