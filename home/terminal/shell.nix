{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        cat = lib.getExe pkgs.bat;
        df = lib.getExe pkgs.duf;
        ff = "fzf | xargs nvim";
        find = lib.getExe pkgs.fd;
        ggpull = "git pull origin $(git branch --show-current)";
        ggpush = "git push origin $(git branch --show-current)";
        grep = lib.getExe pkgs.ripgrep;
        ll = "ls -al";
        r-s = "nh os switch";
        tree = lib.getExe pkgs.eza;
        v = "nvim";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        # Prompt comes from Starship; an omz theme here would just be overridden.
        theme = "";
      };
    };

    atuin.enable = true;

    carapace.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide.enable = true;

    nix-index.enable = true;
    nix-index-database.comma.enable = true;

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        format = lib.concatStrings [
          "[](#cba6f7)"
          "$username"
          "[](bg:#89b4fa fg:#cba6f7)"
          "$directory"
          "[](fg:#89b4fa bg:#fab387)"
          "$git_branch"
          "$git_status"
          "[](fg:#fab387 bg:#a6e3a1)"
          "$c"
          "$elixir"
          "$nodejs"
          "$rust"
          "[](fg:#a6e3a1 bg:#94e2d5)"
          "[](fg:#94e2d5 bg:#74c7ec)"
          "[ ](fg:#74c7ec)"
        ];

        username = {
          show_always = false;
          style_user = "bg:#cba6f7";
          style_root = "bg:#cba6f7";
          format = "[$user ]($style)";
          disabled = true;
        };

        os = {
          style = "bg:#cba6f7";
          disabled = false; # Disabled by default
        };

        directory = {
          style = "bg:#89b4fa";
          format = "[ $path ](bg:#89b4fa fg:#11111b)($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        directory.substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };

        c = {
          symbol = " ";
          style = "bg:#a6e3a1";
          format = "[ $symbol ($version) ]($style)";
        };

        elixir = {
          symbol = " ";
          style = "bg:#a6e3a1 fg:#11111b";
          format = "[ $symbol ($version) ]($style)";
        };

        git_branch = {
          symbol = "";
          style = "bg:#fab387";
          format = "[ $symbol $branch ](bg:#fab387 fg:#11111b)($style)";
        };

        git_status = {
          style = "bg:#fab387";
          format = "[$all_status$ahead_behind ](bg:#fab387 fg:#11111b)($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:#a6e3a1";
          format = "[ $symbol ($version) ]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:#a6e3a1";
          format = "[ $symbol ($version) ]($style)";
        };

        time = {
          disabled = true;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#74c7ec";
          format = "[ ♥ $time ]($style)";
        };
      };
    };
  };
}
