{ powerProfile }: {
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  desktopManager.cosmic.enable = true;

  displayManager = {
    cosmic-greeter.enable = true;
    autoLogin = {
      enable = false;
      user = "linkava";
    };
  };

  flatpak.enable = true;
  system76-scheduler.enable = true;

  scx.enable = true;

  scx.scheduler = if powerProfile == "performance" then "scx_lavd" else "scx_bpfland";

  scx.extraArgs =
    if powerProfile == "performance" then
      [ "--autopower" ]
    else
      [
        "-m"
        "powersave"
      ];
}
