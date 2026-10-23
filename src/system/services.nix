{ powerProfile, pkgs }: {
  # Installs 90-brightnessctl.rules: makes /sys/class/backlight/*/brightness
  # group-writable for the "video" group, so non-root brightness changes work.
  udev.packages = [ pkgs.brightnessctl ];

  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  pulseaudio.enable = false;

  displayManager = {
    noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "niri";
        user.default = "linkava";
        appearance.scheme = "Noctalia";
        keyboard.layout = "us";
        clock.enabled = true;
      };
    };
    defaultSession = "niri";
  };

  clamav = {
    updater.enable = true;
  };

  tor = {
    enable = true;
    enableGeoIP = true;

    client.enable = true;
  };

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
