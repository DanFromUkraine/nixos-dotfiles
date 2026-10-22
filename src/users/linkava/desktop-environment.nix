{ pkgs, powerProfile, ... }: {
  programs.noctalia = {
    enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      outputs."eDP-1".mode = {
        width = 2880;
        height = 1800;
        refresh = if powerProfile == "eco" then 60.001 else 120.0;
      };

      bar.main = {
        position = "left";
      };
    };
  };

  wayland.windowManager.niri = {
    enable = true;
    enableDefaultConfig = true;
    settings = {

      layout.focus-ring = {
        width = 2;
        active-color = "#cba6f7";
      };

      window-rule = {
        geometry-corner-radius = 12;
        clip-to-geometry = true;
      };

      binds = {
        "Mod+T".spawn = [ "ghostty" ];
        "Mod+E".spawn = [ "dolphin" ];
        "Mod+B".spawn = [
          "sh"
          "-c"
          ''wtype -s 100 -d 40 -- "$(rofi-rbw --selector rofi --action print --target password)"''
        ];
        "Mod+Shift+Comma".spawn = [
          "noctalia"
          "msg"
          "settings-toggle"
        ];
        "Mod+Space".spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "launcher"
        ];
        "Mod+Y".spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "clipboard"
        ];
        "Mod+P".spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "control-center"
        ];
        "Mod+Shift+J".focus-workspace-down = { };
        "Mod+Shift+K".focus-workspace-up = { };
        "Mod+Ctrl+J".move-column-to-workspace-down = { };
        "Mod+Ctrl+K".move-column-to-workspace-up = { };
        "Mod+Shift+S".spawn = [
          "noctalia"
          "msg"
          "screenshot-region"
        ];
        "Print".spawn = [
          "noctalia"
          "msg"
          "screenshot-fullscreen"
        ];
        "Mod+Alt+R".spawn = [
          "noctalia"
          "msg"
          "plugin"
          "noctalia/screen_recorder:service"
          "all"
          "start"
          "focused"
        ];
        "Mod+Ctrl+R".spawn = [
          "noctalia"
          "msg"
          "plugin"
          "noctalia/screen_recorder:service"
          "all"
          "stop"
        ];
        "Mod+Shift+R".spawn = [
          "noctalia"
          "msg"
          "plugin"
          "noctalia/screen_recorder:service"
          "all"
          "start"
          "region"
        ];
        "Mod+D".spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "raycursive/niri-displays:panel"
        ];
      };
      input.keyboard.xkb = {
        layout = "us,ua";
        options = "grp:alt_shift_toggle";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-termfilechooser
    ];
  };

  xdg.portal.config.common = {
    "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
  };

  home.sessionVariables.TERMCMD = "ghostty --class=org.local.filechooser -e";

  xdg.configFile."xdg-desktop-portal-termfilechooser/config" = {
    force = true;
    text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    '';
  };
}
