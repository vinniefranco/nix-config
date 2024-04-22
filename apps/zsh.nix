{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = {
      ff = "fzf | xargs nvim";
      la = "eza -a --icons --git";
      ll = "eza -al --icons --git";
      r-h = "home-manager switch --flake /home/vinnie/.dotfiles#vinnie";
      r-s = "sudo nixos-rebuild switch --flake /home/vinnie/.dotfiles#surface";
      r-u = "cd ~/.dotfiles && nix flake update";
      v = "nvim";
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
