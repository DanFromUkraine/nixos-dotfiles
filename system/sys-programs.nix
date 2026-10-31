{ isGame, pkgs }: {
  steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
  };
  gpu-screen-recorder.enable = true;
  niri.enable = true;

  wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  gamemode.enable = isGame;
  nix-ld.enable = true;
  zsh.enable = true;
}
