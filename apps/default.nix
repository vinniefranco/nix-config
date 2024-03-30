{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./sway.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
