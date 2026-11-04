{
  pkgs,
  inputs,
  config,
  ...
}:

let
  flakes = [
    inputs.nixvim.homeModules.nixvim
    inputs.noctalia.homeModules.default
  ];
in
{
  imports = [
    ./desktop-environment.nix
    ./programs/pi.nix
    ./programs/vscode.nix
  ]
  ++ flakes;

  xdg.configFile."niri/config.kdl".force = true;

  home = {
    username = "linkava";
    homeDirectory = "/home/linkava";
    stateVersion = "25.11";
  };

  programs = {
    nixvim = import ./programs/nvim.nix { inherit config pkgs inputs; };
    ssh = import ./programs/ssh.nix;
    zsh = import ./programs/zsh.nix;

    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
      keymap.mgr.prepend_keymap = [
        {
          on = [
            "c"
            "y"
          ];
          run = "shell -- [ -f %h ] && wl-copy < %h || true";
          desc = "copy contents of the file";
        }
      ];
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
        theme = "dark:Catppuccin Frappe,light:Catppuccin Latte";
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
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    home-manager.enable = true;
  };
}
