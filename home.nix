{ config, pkgs, ... }:

{
  home.username = "vinnie";
  home.homeDirectory = "/home/vinnie";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    repgrep
    fd
    lua-language-server
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/root/etc/profile.d/hm-session-vars.sh
  #
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
    };
  };
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -al";
      v = "nvim";
      update-lock = "cd ~/.dotfiles && nix flake update";
      r-s = "sudo nixos-rebuild switch --flake /home/vinnie/.dotfiles#default";
      r-h = "home-manager switch --flake /home/vinnie/.dotfiles#vinnie";
    };

    oh-my-zsh.enable = true;
    oh-my-zsh.theme = "robbyrussell";
    oh-my-zsh.plugins = [ 
      "direnv"
      "git" 
      "sudo" 
    ];
  };

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
      {
        plugin = Navigator-nvim;
        config = toLuaFile ./nvim/plugin/navigator.lua;
      }

      {
        plugin = oil-nvim;
        config = toLuaFile ./nvim/plugin/oil.lua;
      }

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugin/lsp.lua;
      }

      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }

      neodev-nvim

      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/cmp.lua;
      }

      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }

      telescope-fzf-native-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets

      lualine-nvim
      nvim-web-devicons

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

      vim-nix

      {
        plugin = onedarker-nvim;
        config = "colorscheme onedarker";
      }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
    '';

    # extraLuaConfig = ''
    #   ${builtins.readFile ./nvim/options.lua}
    #   ${builtins.readFile ./nvim/plugin/lsp.lua}
    #   ${builtins.readFile ./nvim/plugin/cmp.lua}
    #   ${builtins.readFile ./nvim/plugin/telescope.lua}
    #   ${builtins.readFile ./nvim/plugin/treesitter.lua}
    #   ${builtins.readFile ./nvim/plugin/other.lua}
    # '';
  };
  
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
    lfs.enable = true;
    userName = "vinniefranco";
    userEmail = "vince@freshivore.net";
  }; 

  programs.kitty = {
    enable = true;
    theme = "One Dark";
    font.name = "FiraCodeNFM-Med";
    font.size = 9;
  };
  programs.tmux = {
    baseIndex = 1;
    escapeTime = 0;
    enable = true;
    extraConfig = ''
    set-option -g focus-events on
    set-window-option -g xterm-keys on

    # Smart pane switching with awareness of vim splits
    is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|(n)?vim?)(diff)?$"'
    bind -n M-n if-shell "$is_vim" "send-keys C-h" "select-pane -L"
    bind -n M-e if-shell "$is_vim" "send-keys C-j" "select-pane -D"
    bind -n M-i if-shell "$is_vim" "send-keys C-k" "select-pane -U"
    bind -n M-o if-shell "$is_vim" "send-keys C-l" "select-pane -R"

    # act like vim
    bind n select-pane -L
    bind e select-pane -D
    bind i select-pane -U
    bind o select-pane -R
    bind-key -r C-l select-window -t :-
    bind-key -r C-u select-window -t :+

    bind Up resize-pane -U 15
    bind Down resize-pane -D 15
    bind Left resize-pane -L 25
    bind Right resize-pane -R 25
    '';
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-x";
    plugins = with pkgs; [
      tmuxPlugins.dracula
    ];
    terminal = "tmux-256color";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
