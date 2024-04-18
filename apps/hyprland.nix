{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd &"
        "nm-applet &"
        "blueman-applet &"
        "hyprpaper &"
        "waybar &"
      ];
      input = {
        kb_options = "caps:escape";
        follow_mouse = 1;
        natural_scroll = 0;
        force_no_accel = 0;
        sensitivity = 3.0;
        touchpad = {
          disable_while_typing = true;
          clickfinger_behavior = true;
        };
      };

      general = {
        "$browser" = "chromium";
        "$files" = "thunar";
        "$term" = "kitty";
        "$menu" = "wofi";
        "col.active_border" = "rgba(b3ff1aee) rgba(ffccaaee)";
        border_size = 1;
        gaps_in = 5;
        gaps_out = 5;
        layout = "dwindle";
        no_border_on_floating = true;
      };

      decoration = {
        rounding = 6;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        drop_shadow = false;
        "col.shadow" = "0x66000000";
        blurls = [
          "gtk-layer-shell"
          "lockscreen"
        ];
      };

      dwindle = {
        no_gaps_when_only = false;
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true;
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];

        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "windowsMove, 1, 4, default"
          "border, 1, 10, default"
          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces, 1, 6, default"
          "borderangle, 1, 20, default, loop"
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

      bind= [
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
        ",XF86AudioRaiseVolume,exec,volume --inc"
        ",XF86AudioLowerVolume,exec,volume --dec"
        ",XF86AudioMute,exec,volume --toggle"
        ",XF86AudioMicMute,exec,volume --toggle-mic"
        ",XF86AudioNext,exec,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
        ",XF86AudioPrev,exec,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
        ",XF86AudioPlay,exec,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
        "SUPER,Q,killactive,"
        "SUPER,C,killactive,"
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
        "SUPER_SHIFT,1,movetoworkspace,1"
        "SUPER_SHIFT,2,movetoworkspace,2"
        "SUPER_SHIFT,3,movetoworkspace,3"
        "SUPER_SHIFT,4,movetoworkspace,4"
        "SUPER_SHIFT,5,movetoworkspace,5"
        "SUPER_SHIFT,6,movetoworkspace,6"
      ];

      windowrule = [
        "float, file_progress"
        "float, confirm"
        "float, dialog"
        "size 800 600, dialog"
        "float, download"
        "float, notification"
        "float, error"
        "float, splash"
        "float, confirmreset"
        "float, title:Open File"
        "size 800 600, title:Open File"
        "bordersize 4, title:Open File"
        "animation popin, title:Open File"
        "float, title:branchdialog"
        "float, Lxappearance"
        "float, title:Bluetooth Devices"
        "size 800 600, title:Bluetooth Devices"
        "float, Rofi"
        "animation none,wofi"
        "float, viewnior"
        "float, Viewnior"
        "float, feh"
        "float, zoom"
        "float, pavucontrol-qt"
        "float, pavucontrol"
        "float, file-roller"
        "fullscreen, wlogout"
        "float, title:wlogout"
        "fullscreen, title:wlogout"
        "idleinhibit focus, mpv"
        "idleinhibit fullscreen, firefox"
        "float, title:^(Media viewer)$"
        "float, title:^(Volume Control)$"
        "float, title:^(Picture-in-Picture)$"
        "size 800 600, title:^(Volume Control)$"
        "move 75 44%, title:^(Volume Control)$"
        "float,kitty-float"
        "float,yad|nm-connection-editor|pavucontrolk"
        "float,xfce-polkit|kvantummanager|qt5ct"
        "float,feh|Viewnior|Gpicview|Gimp|MPlayer"
        "float,VirtualBox Manager|qemu|Qemu-system-x86_64"
        "float,kitty-full"
        "move 0 0,kitty-full"
        "size 100% 100%,kitty-full"
        "float,wlogout"
        "move 0 0,wlogout"
        "size 100% 100%,wlogout"
        "animation slide,wlogout"
      ];

      monitor = [
        "eDP-1,highres,0x1452,1.6"
        "DP-2,highres,0x0,1.5"
      ];
    };
  };
}