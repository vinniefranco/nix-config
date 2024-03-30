{ config, pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      keybindings = let 
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        "${modifier}+Control+q" = "kill";
        "${modifier}+n" = "focus left";
        "${modifier}+e" = "focus down";
        "${modifier}+i" = "focus up";
        "${modifier}+o" = "focus right";
        "${modifier}+Shift+n" = "move left";
        "${modifier}+Shift+e" = "move down";
        "${modifier}+Shift+i" = "move up";
        "${modifier}+Shift+o" = "move right";
        "${modifier}+Left" = "focus left";
        "${modifier}+Up" = "focus down";
        "${modifier}+Down" = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Up" = "move down";
        "${modifier}+Shift+Down" = "move up";
        "${modifier}+Shift+Right" = "move right";
      };
      output = {
        "*" = {
          bg = "~/Pictures/dystopia.jpg fill";
        };
        eDP-1 = {
          pos = "1080 1680 res 2880x1920";
          scale = "1.5";
        };
        DP-2 = {
          pos = "0 0 res 3456x2160";
          scale = "1.4";
        };
      };
      modifier = "Mod4";
      terminal = "kitty";
    };
  };
}
