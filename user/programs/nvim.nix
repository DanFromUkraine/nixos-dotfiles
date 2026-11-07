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
    # pi-nvim
    {
      mode = "n";
      key = "<Space>pp";
      action = "<cmd>Pi<CR>";
      options.desc = "Pi: send dialog (file + prompt)";
    }
    {
      mode = "x";
      key = "<Space>pa";
      action = ":'<,'>Pi<CR>";
      options.desc = "Pi: send dialog for selection";
    }
    {
      mode = "n";
      key = "<Space>pb";
      action = "<cmd>PiSendBuffer<CR>";
      options.desc = "Pi: send whole buffer";
    }
    {
      mode = "n";
      key = "<Space>pf";
      action = "<cmd>PiSendFile<CR>";
      options.desc = "Pi: send file path";
    }
    {
      mode = "n";
      key = "<Space>pg";
      action = "<cmd>PiPing<CR>";
      options.desc = "Pi: ping session";
    }
    {
      mode = "n";
      key = "<Space>ps";
      action = "<cmd>PiSessions<CR>";
      options.desc = "Pi: list sessions";
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
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "pi-nvim";
      version = "unstable-2026-10-12";

      src = pkgs.fetchFromGitHub {
        owner = "carderne";
        repo = "pi-nvim";
        rev = "b10a3cc94583cc232645f0e49533e282a3486c0d";
        hash = "sha256-+aToqE10rq8mebxMfkf8r+aIrZpE/rdF4xdWol41lV0=";
      };
    })
  ];

  extraConfigLua = ''
    require("pi-nvim").setup({
      set_default_keymaps = false,
    })
  '';

  userCommands.Nt = {
    command = "Neotree <args>";
    nargs = "*";
  };
}
