{ config, pkgs, lib, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals =  [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk];
    config = { sway.default = ["wlr" "gtk"]; };
  };

   home.packages = with pkgs; [ 
    sweet
    bibata-cursors
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Sweet-Dark";
      package = pkgs.arc-theme;
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Adwaita";
      size = 24;
    };
    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application--prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application--prefer-dark-theme=1
      '';
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
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

        "${modifier}+x" = "exec wlogout";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+w" = "exec vivaldi";
        "${modifier}+d" = "exec ${pkgs.wofi}/bin/wofi -C ~/.dotfiles/apps/config/wofi/colorsi -s ~/.dotfiles/apps/config/wofi/style.css";
        "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
        "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
        "XF86AudioNext" = "exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";
        "XF86AudioPlay" = "exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
        "XF86AudioPrev" = "exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
        "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";
     };
      gaps = {
        inner = 30;
        outer = 0;
        smartBorders = "off";
      };
      bars = [];
      output = {
        "*" = {
          bg = "~/Pictures/dystopia.jpg fill";
        };
        eDP-1 = {
          pos = "1080 1600 res 2880x1920";
          scale = "1.5";
        };
        DP-2 = {
          pos = "0 0 res 3456x2160";
          scale = "1.4";
        };
      };
      modifier = "Mod4";
      terminal = "kitty";
      startup = [
        { command = "waybar"; }
        { command = "blueman-applet"; }
        { command = "swaync"; }
      ];
      window = {
        titlebar = false;
      };
    };
  };
}
