{ pkgs, powerProfile, ... }: {
    users.users.linkava = {
    isNormalUser = true;
    description = "Danylo";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
    ];
  };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us,ua";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };

    gamemode.enable = if (powerProfile == "performance") then true else false;
  }
}
