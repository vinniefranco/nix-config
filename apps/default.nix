{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./sway.nix
    ./tmux.nix
    ./waybar.nix
    ./wofi.nix
    ./wlogout.nix
    ./zsh.nix
  ];
}
