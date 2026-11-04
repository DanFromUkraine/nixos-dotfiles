{ pkgs }: {
  linkava = {
    isNormalUser = true;
    description = "Linkava";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "gamemode"
      "dialout"
      "docker"
      "libvirtd"
      "wireshark"
    ];
    shell = pkgs.zsh;
  };
}
