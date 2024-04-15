{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -al";
      r-h = "home-manager switch --flake /home/vinnie/.dotfiles#vinnie";
      r-s = "sudo nixos-rebuild switch --flake /home/vinnie/.dotfiles#default";
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
}
