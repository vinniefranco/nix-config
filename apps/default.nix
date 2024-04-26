{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./chromium.nix
    ./git.nix
    ./hyprland.nix
    ./kitty.nix
    ./neovim.nix
    ./obs.nix
    ./theme.nix
    ./tmux.nix
    ./waybar.nix
    ./wlogout.nix
    ./wofi.nix
    ./xdg.nix
    ./zsh.nix
  ];
}
