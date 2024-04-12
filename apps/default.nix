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
    ./kitty.nix
    ./neovim.nix
    ./obs.nix
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
