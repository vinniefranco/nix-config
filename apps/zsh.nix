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
    oh-my-zsh.plugins = [ "direnv" "git" "sudo" ];
  };
}
