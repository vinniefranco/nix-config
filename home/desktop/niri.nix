{ config, pkgs, inputs, ...}:
{
  programs.niri = {
    package = pkgs.niri;
    settings = {
      spawn-at-startup = [
        {
          command = [ "noctalia" ];
        }

      ];
      cursor = {
        size = 32;
      };

      binds = with config.lib.niri.actions; {
        "Mod+T".action.spawn = "ghostty";

        "Mod+D".action.spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
        "Mod+S".action.spawn = ["noctalia" "msg" "panel-toggle" "control-center"];
        "Mod+Comma".action.spawn = ["noctalia" "msg" "settings-toggle"];

        "Mod+Q".action = close-window;
        "Mod+F".action = fullscreen-window;
        "Mod+Left".action = focus-column-or-monitor-left;
        "Mod+Right".action = focus-column-or-monitor-right;
        "Mod+Up".action = focus-window-or-workspace-up;
        "Mod+Down".action = focus-window-or-workspace-down;

        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Up".action = move-window-up;
        "Mod+Shift+Down".action = move-window-down;

        "Mod+Shift+0".action.move-window-to-workspace = "work";
        "Mod+Shift+1".action.move-window-to-workspace = "chat";

        "Mod+Ctrl+Right".action.set-column-width = "+10%";
        "Mod+Ctrl+Left".action.set-column-width = "-10%";

        "Mod+Ctrl+Up".action.set-window-height = "+10%";
        "Mod+Ctrl+Down".action.set-window-height = "+10%";

        "Mod+Shift+W".action.spawn = "firefox";
        "Mod+Shift+P".action.spawn = "screenshoter";
        "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        "XF86AudioPlay".action.spawn = ["playerctl" "-p" "spotify" "play-pause"];
        "XF86AudioPrev".action.spawn = ["playerctl" "-p" "spotify" "previous"];
        "XF86AudioNext".action.spawn = ["playerctl" "-p" "spotify" "next"];
      };

      input = {
        focus-follows-mouse.enable = true;
      };

      debug = {
        honor-xdg-activation-with-invalid-serial = [];
      };

      outputs."eDP-1" = {
        scale = 1.7;
        mode = {
          width = 2560;
          height = 1600;
          refresh = 60.0;
        };

        position = {
          x = 500;
          y = 1600;
        };
      };

      outputs."DP-2" = {
        scale = 1.4;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 59.997;
        };

        position = {
          x = 0;
          y = 0;
        };
      };

      layer-rules = [
        {
          matches = [
            { namespace = "^noctalia-backdrop"; }
          ];
          place-within-backdrop = true;
        }
      ];

      layout = {
        always-center-single-column = true;
        focus-ring = {
          width = 1;
        };
      };

      prefer-no-csd = true;

      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 6.0;
            bottom-right = 6.0;
            top-left = 6.0;
            top-right = 6.0;
          };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
        {
          matches = [
            { title = "^Picture in Picture$"; }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
      ];

      workspaces = {
        "chat" = {
          open-on-output = "eDP-1";
        };

        "work" = {
          open-on-output = "DP-2";
        };
      };
    };
  };
  programs.noctalia = {
    enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";

        # Let noctalia render its active palette into GTK and Qt apps so the
        # whole desktop tracks the bar (and would follow wallpaper colors too).
        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "gtk3"
            "gtk4"
            "qt"
          ];
        };
      };

      wallpaper = {
        enabled = true;
        default.path = "/home/vinnie/Pictures/Wallpapers/cornelius-dammrich_carabo_gasstation.jpg";
      };
    };
  };
}
