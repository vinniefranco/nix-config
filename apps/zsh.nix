{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
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
  programs.starship = {
    enable = false;
    enableZshIntegration = false;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

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
        "$cmake"
        "$elixir"
        "$erlang"
        "$lua"
        "$nim"
        "$nodejs"
        "$python"
        "$rust"
        "$terraform"
        "$nix_shell"
        "[](fg:#86BBD8 bg:#06969A)"
        "$docker_context"
        "[](fg:#06969A bg:#33658A)"
        "$time"
        "[ ](fg:#33658A)"
      ];

      username = {
        disabled = false;
        format = "[$user ]($style)";
        show_always = true;
        style_root = "bg:#9A348E";
        style_user = "bg:#9A348E";
      };

      os = {
        disabled = false; # Disabled by default
        style = "bg:#9A348E";
      };

      directory = {
        format = "[ $path ]($style)";
        read_only = " 󰌾";
        style = "bg:#DA627D";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "Projects" = "󰜐 ";
          "Sandbox" = " ";
        };
      };


      c = {
        format = "[; $symbol ($version) ]($style)";
        style = "bg:#86BBD8";
        symbol = " ";
      };

      docker_context = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:#86BBD8";
        symbol = " ";
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

      lua = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:#86BBD8";
        symbol = " ";
      };

      nix_shell = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:#86BBD8";
        symbol = " ";
      };

      nodejs = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:#86BBD8";
        symbol = " ";
      };

      python = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:#86BBD8";
        symbol = " ";
      };

      rust = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:#86BBD8";
        symbol = " ";
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#33658A";
        format = "[  ♥ $time ]($style)";
      };
    };
  };
}
