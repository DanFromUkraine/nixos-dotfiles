{ config, lib, pkgs, ... }: {
  enable = true;

  defaultEditor = true;
  colorschemes.catppuccin.enable = true;

  opts = {
    number = true;
    relativenumber = true;
    signcolumn = "yes:1";
    wrap = true;
    linebreak = true;
    breakindent = true;
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
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "nvim-dev-container";
      version = "unstable-2026-05-12";

      src = pkgs.fetchFromGitHub {
        owner = "esensar";
        repo = "nvim-dev-container";
        rev = "365b4c815339d42133829006dce3e5f8b182b771";
        hash = "sha256-O9smm0n3ha1MzRHUrVOmsAcOjqoM+CyLF/BKsjFoY54=";
      };
    })
  ];

  extraConfigLua = ''
    require("devcontainer").setup({
      container_runtime = "docker",
      nvim_install_as_root = true,
    })
  '';
  userCommands.Nt = {
    command = "Neotree <args>";
    nargs = "*";
  };
}
