{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  toLuaFile = file: ''
    lua << EOF
    ${builtins.readFile file}
    EOF
  '';
  oil-gitstatus = pkgs.vimUtils.buildVimPlugin {
    name = "oil-gitstatus";
    src = pkgs.fetchFromGitHub {
      owner = "refractalize";
      repo = "oil-git-status.nvim";
      rev = "839a1a287f5eb3ce1b07b50323032398e63f7ffa";
      hash = "sha256-pTAvkJPmT3eD3XWrYl6nyKSzeRFEHOi8iDCamF1D1Cg=";
    };
  };
  codesnap-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "codesnap-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mistricky";
      repo = "codesnap.nvim";
      rev = "839a1a287f5eb3ce1b07b50323032398e63f7ffa";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  };
in
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    globals.mapleader = " ";
    clipboard.register = "unnamedplus";
    colorschemes.base16 = {
      enable = true;
      colorscheme = "catppuccin";
    };
    enable = true;
    enableMan = true;
    extraConfigLuaPost = ''
      require('oil-git-status').setup({ show_ignored = true })
       -- gray
      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg='NONE', strikethrough=true, fg='#808080' })
      -- blue
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg='NONE', fg='#569CD6' })
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link='CmpIntemAbbrMatch' })
      -- light blue
      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg='NONE', fg='#9CDCFE' })
      vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link='CmpItemKindVariable' })
      vim.api.nvim_set_hl(0, 'CmpItemKindText', { link='CmpItemKindVariable' })
      -- pink
      vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg='NONE', fg='#C586C0' })
      vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link='CmpItemKindFunction' })
      -- front
      vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg='NONE', fg='#D4D4D4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link='CmpItemKindKeyword' })
      vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link='CmpItemKindKeyword' })
       -- transparent bg
      vim.api.nvim_set_hl(0, 'Normal', {guibg=NONE, ctermbg=NONE})
      -- Spelling is good
      vim.api.nvim_set_hl(0, 'SpellBad', { reverse=true, undercurl=true, force })
    '';
    opts = {
      cursorline = true;
      expandtab = true;
      ignorecase = true;
      laststatus = 3;
      list = true;
      listchars = "tab:󰌒,trail:󱁐,nbsp:󰌑";
      number = true;
      numberwidth = 2;
      relativenumber = true;
      shiftwidth = 2;
      signcolumn = "yes";
      smartcase = true;
      smartindent = true;
      softtabstop = 2;
      spell = true;
      spelllang = "en_us";
      tabstop = 2;
      termguicolors = true;
      updatetime = 250;
      undofile = true;
    };
    keymaps = [
      {
        action = ":TestFile<CR>";
        key = "<leader>tt";
        mode = [ "n" ];
      }
      {
        action = ":TestNearest<CR>";
        key = "<leader>ts";
        mode = [ "n" ];
      }
      {
        action = "function() require'flash'.jump() end";
        key = "s";
        lua = true;
        mode = [
          "n"
          "x"
          "o"
        ];
      }
      {
        action = "<CMD>Oil<CR>";
        key = "-";
        mode = [ "n" ];
        options.desc = "Open File Navigator";
      }
      {
        action = "<CMD>NavigatorLeft<CR>";
        key = "<C-h>";
        mode = [
          "n"
          "t"
        ];
        options.desc = "Navigate Left";
      }
      {
        action = "<CMD>NavigatorRight<CR>";
        key = "<C-l>";
        mode = [
          "n"
          "t"
        ];
        options.desc = "Navigate Right";
      }
      {
        action = "<CMD>NavigatorUp<CR>";
        key = "<C-k>";
        mode = [
          "n"
          "t"
        ];
        options.desc = "Navigate Up";
      }
      {
        action = "<CMD>NavigatorDown<CR>";
        key = "<C-j>";
        mode = [
          "n"
          "t"
        ];
        options.desc = "Navigate Down";
      }
      {
        action = "<cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>";
        key = "<leader>ff";
        mode = "n";
        options.desc = "Find Files";
      }
      {
        action = "<cmd>lua require('telescope.builtin').live_grep({hidden = true})<CR>";
        key = "<leader>fg";
        mode = "n";
        options.desc = "Grep Files";
      }
      {
        action = "<cmd>lua require('telescope.builtin').buffers()<CR>";
        key = "<leader>fb";
        mode = "n";
        options.desc = "Find Buffer";
      }
      {
        action = "<cmd>lua require('telescope.builtin').diagnostics()<CR>";
        key = "<leader>fd";
        mode = "n";
        options.desc = "Find Diagnostics";
      }
      {
        action = "<cmd>lua require('telescope.builtin').treesitter()<CR>";
        key = "<leader>ft";
        mode = "n";
        options.desc = "Find Treesitter";
      }
    ];
    plugins = {
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
            { name = "codeium"; }
            { name = "path"; }
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
          ];
        };
      };
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-spell.enable = true;
      cmp-treesitter.enable = true;
      cmp-clippy.enable = true;
      codeium-nvim.enable = true;
      comment.enable = true;
      direnv.enable = true;
      friendly-snippets.enable = true;
      flash = {
        enable = true;
        modes = {
          char.jumpLabels = true;
        };
      };
      luasnip.enable = true;
      gitsigns.enable = true;
      nvim-autopairs.enable = true;
      telescope = {
        enable = true;
        settings = {
          defaults = {
            file_ignore_patterns = [
              "^.git/"
              "^output/"
              "^_build/"
              "node_modules"
            ];
            prompt_prefix = "   ";
            selection_caret = "  ";
            entry_prefix = "  ";
            initial_mode = "insert";
            selection_strategy = "reset";
            sorting_strategy = "ascending";
            layout_strategy = "horizontal";
            layout_config = {
              horizontal = {
                prompt_position = "top";
                preview_width = 0.55;
              };
              vertical = {
                mirror = false;
              };
              width = 0.87;
              height = 0.8;
              preview_cutoff = 120;
            };
            winblend = 0;
            border = { };
            borderchars = [
              "─"
              "│"
              "─"
              "│"
              "╭"
              "╮"
              "╯"
              "╰"
            ];
            color_devicons = true;
          };
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
          bashls.enable = true;
          clangd.enable = true;
          cssls.enable = true;
          eslint.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          taplo.enable = true;
          tailwindcss.enable = true;
          terraformls.enable = true;
          lexical = {
            enable = true;
            filetypes = [
              "elixir"
              "eelixir"
              "heex"
            ];
            rootDir = ''
              function(fname)
                            local lspconfig = require('lspconfig')
                            return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
                          end'';
            cmd = [ "${pkgs.lexical}/bin/lexical" ];
          };
        };
      };
      lspkind.enable = true;
      rust-tools.enable = true;
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
      { plugin = oil-gitstatus; }
      {
        plugin = vim-test;
        config = ''
          lua << EOF
          vim.g["test#strategy"] = "vimux"
          EOF
        '';
      }
      { plugin = vimux; }
    ];
  };
}
