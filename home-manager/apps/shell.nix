{ config, pkgs, lib, ... }: let
  completion = name: ''
    source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
  '';
  completions =
    names:
    builtins.foldl' (prev: str: ''
      ${prev}
      ${str}'') "" (map completion names);
in {
  programs = {
    nushell = {
      enable = true;
      shellAliases = {
        cat = lib.getExe pkgs.bat;
        df = lib.getExe pkgs.duf;
        ff = "fzf | xargs nvim";
        find = lib.getExe pkgs.fd;
        ggpull = "git pull origin $'(git branch --show-current)'";
        ggpush = "git push origin $'(git branch --show-current)'";
        grep = lib.getExe pkgs.ripgrep;
        ll = "ls -al";
        r-h = "home-manager switch --flake /home/vinnie/.dotfiles#vinnie --impure";
        r-s = "sudo nixos-rebuild switch --flake /home/vinnie/.dotfiles";
        tree = lib.getExe pkgs.eza;
        v = "nvim";
      };
      environmentVariables = {
        DIRENV_LOG_FORMAT = ''''; # make direnv quiet
        EDITOR = ''"nvim"'';
        OPENROUTER_API_KEY = (builtins.readFile "/run/user/1000/openrouter_api.key");
        PROMPT_INDICATOR_VI_INSERT = ": ";
        PROMPT_INDICATOR_VI_NORMAL = "〉 ";
        SHELL = ''${lib.getExe pkgs.nushell}'';
        CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
      };
      extraEnv = ''
        use ${pkgs.nu_scripts}/share/nu_scripts/aliases/git/git-aliases.nu
        ${completions [
          "bat"
          "cargo"
          "docker"
          "git"
          "mix"
          "nix"
          "tar"
        ]}

        def record_screen [] {
          wl-screenrec -g $"(slurp)" -f $"screen(date now | format date "%Y-%m-%d-%H%M%S").mp4"
        }
      '';
      settings = {
        show_banner = false;
        edit_mode = "vi";
        history.file_format = "sqlite";

        ls.clickable_links = true;
        rm.always_trash = true;

        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };
    };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = false;
      enableNushellIntegration = true;
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        format = lib.concatStrings [
          "[](#9A348E)"
          "$username"
          "[](bg:#DA627D fg:#9A348E)"
          "$directory"
          "[](fg:#DA627D bg:#FCA17D)"
          "$git_branch"
          "$git_status"
          "[](fg:#FCA17D bg:#86BBD8)"
          "$c"
          "$elixir"
          "$nodejs"
          "$rust"
          "[](fg:#86BBD8 bg:#06969A)"
          "[](fg:#06969A bg:#33658A)"
          "[ ](fg:#33658A)"
        ];

        username = {
          show_always = false;
          style_user = "bg:#9A348E";
          style_root = "bg:#9A348E";
          format = "[$user ]($style)";
          disabled = true;
        };

        os = {
          style = "bg:#9A348E";
          disabled = false; # Disabled by default
        };

        directory = {
          style = "bg:#DA627D";
          format = "[ $path ](bg:#DA627D fg:#11111b)($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        directory.substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };

        c = {
          symbol = " ";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        elixir = {
          symbol = " ";
          style = "bg:#86BBD8 fg:#11111b";
          format = "[ $symbol ($version) ]($style)";
        };

        git_branch = {
          symbol = "";
          style = "bg:#FCA17D";
          format = "[ $symbol $branch ](bg:#FCA17D fg:#11111b)($style)";
        };

        git_status = {
          style = "bg:#FCA17D";
          format = "[$all_status$ahead_behind ](bg:#FCA17D fg:#11111b)($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        time = {
          disabled = true;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#33658A";
          format = "[ ♥ $time ]($style)";
        };
      };
    };
  };
}
