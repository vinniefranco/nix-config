{ pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      variables = [ "--all" ];
    };
    settings = {
      env = [
        "CLUTTER_BACKEND,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "GDK_BACKEND,wayland,x11,*"
        "GDK_SCALE,1"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_ENABLE_HIGHDPI_SCALING,1"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "SDL_VIDEODRIVER,wayland"
        "XCURSOR_SIZE,24"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
      ];
      exec-once = [
        "systemctl --user start hyprpolkitagent"
        "astal-bar"
        "hyprpaper"
        "${lib.getExe pkgs.hyprsunset}"
        "blueman-tray"
        "nm-applet"
      ];
      input = {
        kb_options = "caps:escape";
        follow_mouse = 1;
        natural_scroll = false;
        force_no_accel = false;
        sensitivity = 0;
        touchpad = {
          disable_while_typing = true;
          clickfinger_behavior = true;
        };
      };

      device = {
        name = "pnp0c50:00-222a:550d-stylus";
        output = "eDP-1";
      };

      general = {
        "$browser" = "firefox";
        "$files" = "thunar";
        "$term" = "ghostty";
        "$menu" = "fuzzel";
        border_size = 2;
        gaps_in = 10;
        gaps_out = 10;
        layout = "dwindle";
        no_border_on_floating = true;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      };

      xwayland.force_zero_scaling = true;

      decoration = {
        rounding = 6;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        blurls = [
          "gtk-layer-shell"
          "lockscreen"
        ];
      };

      dwindle = {
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true;
      };

      workspace = [
        "1,monitor:DP-2"
        "2,monitor:DP-2"
        "3,monitor:DP-2"
        "4,monitor:eDP-1"
        "5,monitor:eDP-1"
        "6,monitor:eDP-1"
      ];

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.13,0.99,0.29,1.1"
        ];

        animation = [
          "windows,1,4,overshot,slide"
          "fadeIn,1,10,default"
          "workspaces,1,8.8,overshot,slide"
          "border,1,14,default"
          "borderangle, 1, 8, default"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        vfr = true;
        enable_swallow = true;
        swallow_regex = "^(kitty)$";
      };

      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];

      bind = [
        "SUPER_SHIFT,P,exec,screenshoter"
        "SUPER_SHIFT,S,exec,spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "SUPER,Return,exec,$term"
        "SUPER_SHIFT,Return,exec,$term -f"
        "SUPERALT,Return,exec,$term -s"
        "SUPER,T,exec,$term -F"
        "SUPER_SHIFT,F,exec,$files"
        "SUPER_SHIFT,E,exec,$editor"
        "SUPER_SHIFT,W,exec,$browser"
        "SUPER,D,exec,$menu"
        "SUPER,X,exec,wlogout"
        ",XF86MonBrightnessUp,exec,light --inc"
        ",XF86MonBrightnessDown,exec,light --dec"
        ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ",XF86AudioMute,exec,volumectl -d toggle-mute"
        ",XF86AudioNext,exec,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
        ",XF86AudioPrev,exec,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
        ",XF86AudioPlay,exec,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
        "SUPER,Q,killactive,"
        "CTRLALT,Delete,exit,"
        "SUPER,F,fullscreen,"
        "SUPER,Space,togglefloating,"
        "SUPER,S,pseudo,"
        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"
        "SUPER_SHIFT,n,movewindow,l"
        "SUPER_SHIFT,o,movewindow,r"
        "SUPER_SHIFT,i,movewindow,u"
        "SUPER_SHIFT,e,movewindow,d"
        "SUPERCTRL,n,resizeactive,-20 0"
        "SUPERCTRL,o,resizeactive,20 0"
        "SUPERCTRL,i,resizeactive,0 -20"
        "SUPERCTRL,e,resizeactive,0 20"
        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER_SHIFT,1,movetoworkspace,1"
        "SUPER_SHIFT,2,movetoworkspace,2"
        "SUPER_SHIFT,3,movetoworkspace,3"
        "SUPER_SHIFT,4,movetoworkspace,4"
        "SUPER_SHIFT,5,movetoworkspace,5"
        "SUPER_SHIFT,6,movetoworkspace,6"
        "SUPER_SHIFT,7,movetoworkspace,7"
      ];

      windowrule = [
        "float,title:Open File"
        "size 800 600, title:Open File"
        "bordersize 4, title:Open File"
        "animation popin, title:Open File"
        "float,title:branchdialog"
        "float,title:Bluetooth Devices"
        "size 800 600, title:Bluetooth Devices"
        "float,title:^(FreeCAD)$"
        "float,title:^(Media viewer)$"
        "float,title:^(Volume Control)$"
        "float,title:^(Picture-in-Picture)$"
        "size 800 600,title:^(Volume Control)$"
        "move 75 4%,title:^(Volume Control)$"
      ];
      windowrulev2 = [ "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0" ];
      monitor = [
        "DP-2,3840x2160,0x0,1.5"
        "DP-1,3840x2160@60,0x0,1.5"
        "eDP-1,2560x1600@60,0x1452,1.6"
      ];
    };
  };
}
