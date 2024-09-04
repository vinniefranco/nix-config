{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = {
      ff = "fzf | xargs nvim";
      la = "eza -a --icons --git";
      ls = "eza --icons";
      ll = "eza -al --icons --git";
      r-h = "home-manager switch --flake /home/vinnie/.dotfiles#vinnie --impure";
      r-s = "sudo nixos-rebuild switch --flake /home/vinnie/.dotfiles#v3";
      r-u = "cd ~/.dotfiles && nix flake update";
      v = "nvim";
    };
    syntaxHighlighting = {
      enable = true;
      patterns = {
        "rm -rf *" = "fg=black,bg=red";
      };
      styles = {
        "alias" = "fg=magenta";
      };
      highlighters = [
        "main"
        "brackets"
        "pattern"
      ];
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "direnv"
        "git"
        "sudo"
      ];
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
}
