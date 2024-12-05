{ pkgs, lib, ... }:

{
  programs = {
    nushell = {
      enable = true;
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
        SHELL = ''"${pkgs.unstable.nushell}/bin/nu"'';
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
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        format = lib.concatStrings [
          "$shlvl"
          "$directory"
          "$vcsh"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$pijul_channel"
          "$package"
          "$c"
          "$cobol"
          "$elixir"
          "$elm"
          "$erlang"
          "$haskell"
          "$helm"
          "$kotlin"
          "$lua"
          "$nim"
          "$nodejs"
          "$perl"
          "$purescript"
          "$python"
          "$quarto"
          "$raku"
          "$rlang"
          "$rust"
          "$scala"
          "$solidity"
          "$typst"
          "$vlang"
          "$nix_shell"
          "$spack"
          "$nats"
          "$direnv"
          "$env_var"
          "$custom"
          "$sudo"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$time"
          "$status"
          "$shell"
          "$character"
        ];
      };
    };
  };
}
