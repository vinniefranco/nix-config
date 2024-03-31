{ pkgs, lib, ... }:

let
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
  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;
    viAlias = true;

    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      lsp-zero-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      friendly-snippets
      lualine-nvim
      luasnip
      neodev-nvim
      nvim-web-devicons
      vim-nix
      {
        plugin = flash-nvim;
        config = toLuaFile ./nvim/plugin/flash-nvim.lua;
      }

      {
        plugin = nvim-comment;
        config = toLuaFile ./nvim/plugin/nvim-comment.lua;
      }

      {
        plugin = Navigator-nvim;
        config = toLuaFile ./nvim/plugin/navigator.lua;
      }

      {
        plugin = oil-nvim;
        config = toLuaFile ./nvim/plugin/oil.lua;
      }

      {
        plugin = oil-gitstatus;
        config = toLuaFile ./nvim/plugin/oil-gitstatus.lua;
      }

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugin/lsp.lua;
      }

      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }

      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/cmp.lua;
      }

      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }

      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-bash
          p.tree-sitter-comment
          p.tree-sitter-dockerfile
          p.tree-sitter-json
          p.tree-sitter-lua
          p.tree-sitter-nix
          p.tree-sitter-make
          p.tree-sitter-python
          p.tree-sitter-vim
        ]));
        config = toLuaFile ./nvim/plugin/treesitter.lua;
      }

      {
        plugin = onedarker-nvim;
        config = "colorscheme onedarker";
      }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
    '';
  };
}
