{ isGame }: {
  steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  gamemode.enable = isGame;
  nix-ld.enable = true;
}
