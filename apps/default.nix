{ inputs, ... }:

{
  imports = [
    inputs.hyprlock.homeManagerModules.default
    ./chromium.nix
    ./freecad.nix
    ./fuzzel.nix
    ./git.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./kitty.nix
    ./neovim.nix
    ./obs.nix
    ./theme.nix
    ./tmux.nix
    ./waybar.nix
    ./wlogout.nix
    ./xdg.nix
    ./zsh.nix
  ];
}
