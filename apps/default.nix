{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./portals.nix
    ./sway.nix
    ./theme.nix
    ./tmux.nix
    ./waybar.nix
    ./wlogout.nix
    ./wofi.nix
    ./zsh.nix
  ];
}
