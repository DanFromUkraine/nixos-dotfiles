{
  pkgs,
  inputs,
  config,
  ...
}:

let
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
    jetbrains-toolbox
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
  ];

  systemTools = with pkgs; [
    cliphist
    wl-clipboard
    fuzzel
    wtype
    rofi
    rofi-rbw
    gamescope
    btop
    zathura
    kdePackages.dolphin
  ];
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.noctalia.homeModules.default
  ];

  xdg.configFile."niri/config.kdl".force = true;

  home = {
    username = "linkava";
    homeDirectory = "/home/linkava";
    stateVersion = "25.11";

    packages =
      (with pkgs; [
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
      ])
      ++ programmingTools
      ++ systemTools;
  };

  services = {
    cliphist.enable = true;
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

  programs = {
    yazi = {
      enable = true;

      enableZshIntegration = true;
      shellWrapperName = "y";
    };

    rbw = {
      enable = true;

      settings = {
        email = "const.time.flow@gmail.com";
        pinentry = pkgs.pinentry-gnome3;
      };
    };

    noctalia = {
      enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        bar.main = {
          position = "left";
        };
      };
    };
    ghostty = {
      enable = true;
      settings = {
        theme = "TokyoNight";
        cursor-style = "bar";
      };
    };

    vscode = {
      enable = true;

      package = pkgs.vscode.fhsWithPackages (
        ps: with ps; [
          python3
          platformio-core
          gcc
        ]
      );

      profiles.default.extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        platformio.platformio-vscode-ide
        jnoortheen.nix-ide
        ms-vscode-remote.remote-containers
      ];
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

    nixvim = {
      enable = true;

      defaultEditor = true;
      colorschemes.catppuccin.enable = true;

      opts = {
        number = true;
        relativenumber = true;
        signcolumn = "yes:1";
      };

      keymaps = [
        {
          mode = "n";
          key = "<Space>f";
          action = "<cmd>lua vim.lsp.buf.format()<CR>";
        }
        {
          mode = "n";
          key = "<Space>d";
          action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<cmd>bprevious<CR>";
          options.desc = "Previous buffer";
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<cmd>bnext<CR>";
          options.desc = "Next buffer";
        }
        {
          mode = "n";
          key = "]d";
          action = "<cmd>lua vim.diagnostic.jump({count=1,float=true})<CR>";
        }
        {
          mode = "n";
          key = "[d";
          action = "<cmd>lua vim.diagnostic.jump({count=-1,float=true})<CR>";
        }
        {
          mode = "n";
          key = "]h";
          action = "<cmd>lua require('gitsigns').nav_hunk('next')<CR>";
        }
        {
          mode = "n";
          key = "[h";
          action = "<cmd>lua require('gitsigns').nav_hunk('prev')<CR>";
        }
      ];

      plugins = {
        lualine = {
          enable = true;
          settings.sections.lualine_x = [
            {
              __unkeyed-1 = "%S";
              icon = "󰘳";
              padding = 1;
            }
            "encoding"
            "fileformat"
            "filetype"
          ];
        };
        bufferline.enable = true;
        neo-tree.enable = true;
        telescope.enable = true;
        treesitter.enable = true;
        blink-cmp.enable = true;
        nvim-surround.enable = true;
        mini-bracketed.enable = true;
        gitsigns.enable = true;
        mini-basics = {
          enable = true;
          settings = {
            mappings.windows = true;
            options = {
              extra_ui = true;
              move_with_alt = true;
            };
          };
        };

        lsp = {
          enable = true;
          servers = {
            arduino_language_server = {
              enable = true;

              cmd = [
                "${pkgs.arduino-language-server}/bin/arduino-language-server"
                "-cli"
                "${pkgs.arduino-cli}/bin/arduino-cli"
                "-clangd"
                "${pkgs.clang-tools}/bin/clangd"
                "-fqbn"
                "arduino:renesas_uno:unor4wifi"
              ];

              extraOptions.capabilities = {
                textDocument.semanticTokens = config.lib.nixvim.mkRaw "vim.NIL";
                workspace.semanticTokens = config.lib.nixvim.mkRaw "vim.NIL";
              };
            };
            clangd.enable = true;

            nixd = {
              enable = true;
              settings.formatting.command = [ "nixfmt" ];
            };
          };
        };
      };

      userCommands.Nt = {
        command = "Neotree <args>";
        nargs = "*";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "gitlab.com" = {
          hostName = "gitlab.com";
          user = "git";
          identityFile = "~/nixos-config/src/secrets/gitlab/gitlab";
          identitiesOnly = true;
        };

        "github.com" = {
          hostName = "github.com";
          user = "git";
          identityFile = "~/nixos-config/src/secrets/github/github";
          identitiesOnly = true;
        };
      };
    };

    home-manager.enable = true;

    fuzzel = {
      enable = true;

      settings = {
        main = {
          prompt = "📋 ";
          lines = 15;
          width = 40;
          horizontal-pad = 15;
          vertical-pad = 15;
        };

        border.radius = 15;

        colors = {
          background = "1e1e2eff";
          text = "cdd6f4ff";
          match = "89b4faff";
          selection = "313244ff";
          selection-text = "cdd6f4ff";
          border = "89b4faff";
        };
      };
    };

    zsh = {
      enable = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        minecraft = "gamescope -W 1920 -H 1200 --force-grab-cursor -- freesmlauncher";
      };

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";

        plugins = [
          "git"
          "sudo"
        ];
      };
    };
  };
}
