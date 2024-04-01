{ pkgs, lib, inputs, ... }:

let
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  nvim-tundra = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-tundra";
    src = pkgs.fetchFromGitHub {
      owner = "sam4llis";
      repo = "nvim-tundra";
      rev = "374ec2e2075ebe699a20d29e0c141cf5113adf0c";
      hash = "sha256-pTAvkJPmT3eD3XWrYl6nyKSzeRFEHOi8iDCamF1D1Cg=";
    };
  };
  oil-gitstatus = pkgs.vimUtils.buildVimPlugin {
    name = "oil-gitstatus";
    src = pkgs.fetchFromGitHub {
      owner = "refractalize";
      repo = "oil-git-status.nvim";
      rev = "839a1a287f5eb3ce1b07b50323032398e63f7ffa";
      hash = "sha256-pTAvkJPmT3eD3XWrYl6nyKSzeRFEHOi8iDCamF1D1Cg=";
    };
  };
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    globals = {
      mapleader = " ";
    };
    colorschemes.tokyonight.enable = true;
    enable = true;
    enableMan = true;
    extraConfigLuaPost = ''
require('oil-git-status').setup({
  show_ignored = true
})
    '';
    opts = {
      cursorline = true;
      expandtab = true;
      ignorecase = true;
      laststatus = 3;
      listchars = "tab:>-,trail:●,nbsp:+";
      number = true;
      numberwidth = 2;
      relativenumber = true;
      shiftwidth = 2;
      signcolumn = "yes";
      smartcase = true;
      smartindent = true;
      softtabstop = 2;
      tabstop = 2;
      termguicolors = true;
      updatetime = 250;
    };
    keymaps = [
      {
        mode = [ "n" "x" "o" ];
        key = "s";
        action = "function() require'flash'.jump() end";
        lua = true;
      }
      {
        action = "<CMD>Oil<CR>";
        key = "-";
        mode = ["n"];
      }
      {
        action = "<CMD>NavigatorLeft<CR>";
        key = "<C-h>";
        mode = ["n" "t"];
      }
      {
        action = "<CMD>NavigatorRight<CR>";
        key = "<C-l>";
        mode = ["n" "t"];
      }
      {
        action = "<CMD>NavigatorUp<CR>";
        key = "<C-k>";
        mode = ["n" "t"];
      }
      {
        action = "<CMD>NavigatorDown<CR>";
        key = "<C-j>";
        mode = ["n" "t"];
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>lua require('telescope.builtin').live_grep({hidden = true})<CR>";
        options.desc = "Grep Files";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>lua require('telescope.builtin').buffers()<CR>";
        options.desc = "Find Buffer";
      }
      {
        mode = "n";
        key = "<leader>fd";
        action = "<cmd>lua require('telescope.builtin').diagnostics()<CR>";
        options.desc = "Find Diagnostics";
      }
      {
        mode = "n";
        key = "<leader>ft";
        action = "<cmd>lua require('telescope.builtin').treesitter()<CR>";
        options.desc = "Find Treesitter";
      }
    ];
    plugins = {
      nvim-autopairs.enable = true;
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          completion.completeopt = "noselect";
          preselect = "None";

          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };

          sources = [
            {name = "path";}
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "buffer";}
          ];
        };
      };
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-spell.enable = true;
      cmp-treesitter.enable = true;
      comment.enable = true;
      direnv.enable = true;
      gitsigns.enable = true;
      flash = {
        enable = true; 
        modes = {
          char.jumpLabels = true;
        };
      };
      telescope = {
        enable = true;
        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^output/"
            "^_build/"
            "node_modules"
          ];
        };
      };
      treesitter = {
        enable = true;
        nixvimInjections = true;
      };
      oil = {
        enable = true;
        settings.win_options.signcolumn = "yes:2";
      };
      lualine.enable = true;
      lsp = {
        enable = true;
        servers = {
          lua-ls.enable = true;
          nixd.enable = true;
        };

      }; 
      lspkind.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = Navigator-nvim;
        optional = true;
        config = ''
packadd! Navigator.nvim
lua << EOF
  require("Navigator").setup()
EOF
        '';
      }
      {
        plugin = oil-gitstatus;
      }
    ];
  };
  #     friendly-snippets
  #     lualine-nvim
  #     luasnip
  #     neodev-nvim
  #     nvim-web-devicons
  #     vim-nix
  #
  #     {
  #       plugin = (nvim-treesitter.withPlugins (p: [
  #         p.tree-sitter-bash
  #         p.tree-sitter-comment
  #         p.tree-sitter-dockerfile
  #         p.tree-sitter-json
  #         p.tree-sitter-lua
  #         p.tree-sitter-nix
  #         p.tree-sitter-make
  #         p.tree-sitter-python
  #         p.tree-sitter-vim
  #       ]));
  #       config = toLuaFile ./nvim/plugin/treesitter.lua;
  #     }
  #
  #     {
  #       plugin = onedarker-nvim;
  #       config = "colorscheme onedarker";
  #     }
  #   ];
}
