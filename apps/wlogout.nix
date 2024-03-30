{ lib, pkgs, ... }:

{
  programs.wlogout = {
    enable = true;
    style = ./config/wlogout/style.css;
    layout = [
      {
        label = "logout";
        action = "swaymsg exit";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl hibernate";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        keybind = "s";
      }
    ];
  };
}
