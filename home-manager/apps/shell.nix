{ pkgs, lib, ... }:

{
  programs = {
    nushell = {
      enable = true;
      package = pkgs.unstable.nushell;
      shellAliases = {
        ff = "fzp | xargs nvim";
        v = "nvim";
        ll = "ls -al";
        r-h = "home-manager switch --flake /home/vinnie/.dotfiles#vinnie --impure";
        r-s = "sudo nixos-rebuild switch --flake /home/vinnie/.dotfiles#v3";
        cat = lib.getExe pkgs.bat;
        df = lib.getExe pkgs.duf;
        find = lib.getExe pkgs.fd;
        grep = lib.getExe pkgs.ripgrep;
        tree = lib.getExe pkgs.eza;
      };
      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = ": ";
        PROMPT_INDICATOR_VI_NORMAL = "〉 ";
        DIRENV_LOG_FORMAT = ''""''; # make direnv quiet
        SHELL = ''"${lib.getExe pkgs.unstable.nushell}"'';
        EDITOR = ''"nvim"'';
      };
      extraConfig =
        let
          conf = builtins.toJSON {
            show_banner = false;
            edit_mode = "vi";

            ls.clickable_links = true;
            rm.always_trash = true;

            table = {
              mode = "rounded";
              index_mode = "always";
              header_on_separator = false;
            };

            cursor_shape = {
              vi_insert = "line";
              vi_normal = "block";
            };

            menus = [
              {
                name = "completion_menu";
                only_buffer_difference = false;
                marker = "? ";
                type = {
                  layout = "columnar"; # list, description
                  columns = 4;
                  col_padding = 2;
                };
                style = {
                  text = "magenta";
                  selected_text = "blue_reverse";
                  description_text = "yellow";
                };
              }
            ];
          };
          completion = name: ''
            source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
          '';
          completions =
            names:
            builtins.foldl' (prev: str: ''
              ${prev}
              ${str}'') "" (map completion names);
        in
        ''
          let carapace_completer = {|spans|
            carapace $spans.0 nushell $spans | from json
          }
          $env.config = ${conf};
          ${completions [
            "git"
            "nix"
            "man"
            "cargo"
          ]}
        '';
    };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
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
      package = pkgs.unstable.starship;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        format = lib.concatStrings [
          "[](#9A348E)"
          "$os"
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
          "$docker_context"
          "[](fg:#06969A bg:#33658A)"
          "$time"
          "[ ](fg:#33658A)"
        ];

        username = {
          show_always = false;
          style_user = "bg:#9A348E";
          style_root = "bg:#9A348E";
          format = "[$user ]($style)";
          disabled = false;
        };

        os = {
          style = "bg:#9A348E";
          disabled = true; # Disabled by default
        };

        directory = {
          style = "bg:#DA627D";
          format = "[ $path ]($style)";
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
          style = "bg:#86BBD8";
          format = "[ $symbol ($version) ]($style)";
        };

        git_branch = {
          symbol = "";
          style = "bg:#FCA17D";
          format = "[ $symbol $branch ]($style)";
        };

        git_status = {
          style = "bg:#FCA17D";
          format = "[$all_status$ahead_behind ]($style)";
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
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#33658A";
          format = "[ ♥ $time ]($style)";
        };
      };
    };
  };
}
