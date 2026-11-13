{
  config,
  pkgs,
  inputs,
  ...
}:
{
  enable = true;
  nixpkgs.source = inputs.nixpkgs;
  defaultEditor = true;
  colorschemes.catppuccin.enable = true;

  opts = {
    number = true;
    relativenumber = true;
    wrap = true;
    linebreak = true;
    breakindent = true;
    tabstop = 2;
    expandtab = true;
    shiftwidth = 2;
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
    # codecompanion
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Space>cc";
      action = "<cmd>CodeCompanionChat Toggle<CR>";
      options.desc = "CodeCompanion: toggle chat";
    }
    {
      mode = "n";
      key = "<Space>cn";
      action = "<cmd>CodeCompanionChat<CR>";
      options.desc = "CodeCompanion: new chat (OpenCode + markitdown)";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Space>cA";
      action = "<cmd>CodeCompanionActions<CR>";
      options.desc = "CodeCompanion: actions palette";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Space>ci";
      action = "<cmd>CodeCompanion<CR>";
      options.desc = "CodeCompanion: inline prompt";
    }
    {
      mode = "v";
      key = "<Space>cs";
      action = ":'<,'>CodeCompanion<CR>";
      options.desc = "CodeCompanion: inline prompt on selection";
    }
    {
      mode = "v";
      key = "<Space>c+";
      action = ":'<,'>CodeCompanionChat Add<CR>";
      options.desc = "CodeCompanion: add selection to chat";
    }
    {
      mode = "n";
      key = "<Space>cf";
      action = "<cmd>CCFetch<CR>";
      options.desc = "CodeCompanion: fetch URL/file via markitdown";
    }
    {
      mode = "n";
      key = "<Space>cr";
      action = "<cmd>CodeCompanionCodeReview<CR>";
      options.desc = "CodeCompanion: code review";
    }
    {
      mode = "n";
      key = "<Space>cm";
      action = "<cmd>checkhealth codecompanion<CR>";
      options.desc = "CodeCompanion: health check";
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
    neo-tree = {
      enable = true;
      settings.filesystem.use_libuv_file_watcher = true;
    };
    telescope.enable = true;
    treesitter.enable = true;
    blink-cmp.enable = true;
    nvim-surround.enable = true;
    mini-bracketed.enable = true;
    gitsigns.enable = true;
    codecompanion = {
      enable = true;
      settings = {
        interactions = {
          chat.adapter = "opencode";
          inline.adapter = "opencode";
        };
      };
    };
    render-markdown = {
      enable = true;
      settings.file_types = [
        "markdown"
        "codecompanion"
      ];
    };
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
        clangd = {
          enable = true;
        };

        nixd = {
          enable = true;
          settings.formatting.command = [ "nixfmt" ];
        };
      };
    };
  };
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "auto-reload";
      version = "1.0";

      src = pkgs.fetchFromGitHub {
        owner = "ycdzj";
        repo = "auto-reload.nvim";
        rev = "635e63d46bcad9c8dc0b0a8c483209e1f2aae465";
        hash = "sha256-JKKwi7tFIfF1UbD1F75zcurO6cmZPvxAT9i2nP5rQHo=";
      };
    })
  ];

  extraConfigLua = ''
    require('auto-reload').setup()
  '';

  userCommands.Nt = {
    command = "Neotree <args>";
    nargs = "*";
  };
}
