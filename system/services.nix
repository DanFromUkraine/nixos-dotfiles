{ powerProfile, pkgs }: {
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

  searx = {
    enable = true;
    environmentFile = "/home/linkava/nixos-config/secrets/apis/.searxng.env";
    settings = {
      general = {
        debug = false;
      };
      server = {
        bind_address = "127.0.0.1";
        port = 2202;
      };
      search.formats = [
        "html"
        "json"
      ];
    };
  };
}
