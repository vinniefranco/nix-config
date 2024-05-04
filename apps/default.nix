{ inputs, ... }:

{
  imports = [
    inputs.hyprlock.homeManagerModules.default
    ./chromium.nix
    ./freecad.nix
    ./git.nix
    ./hyprland.nix
    ./hyprlock.nix
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
