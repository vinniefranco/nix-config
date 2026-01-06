{ config, pkgs, inputs, ...}:
let
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  programs.niri = {
    package = pkgs.niri;
    settings = {
      cursor = {
        size = 32;
      };

      binds = with config.lib.niri.actions; {
        "Mod+T".action.spawn = "ghostty";
        "Mod+D".action.spawn = noctalia "launcher toggle";
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

        "Mod+Ctrl+Right".action.set-column-width = "+10%";
        "Mod+Ctrl+Left".action.set-column-width = "-10%";

        "Mod+Ctrl+Up".action.set-window-height = "+10%";
        "Mod+Ctrl+Down".action.set-window-height = "+10%";

        "Mod+Shift+W".action.spawn = "firefox";
        "Mod+Shift+P".action.spawn = "screenshoter";
        "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
        "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
        "XF86AudioNext".action.spawn = ["playerctl" "next"];
      };
      input = {
        focus-follows-mouse.enable = true;
      };

      outputs."eDP-1" = {
        mode = {
          width = 2560;
          height = 1600;
          refresh = 60.0;
        };

        position = {
          x = 0;
          y = 1320;
        };
      };

      outputs."DP-2" = {
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

      layout = {
        focus-ring = {
          width = 1;
          active = {
            gradient = {
              from = "#80c8ff";
              to = "#c7ff7f";
              angle = 45;
            };
          };
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
      ];
    };
  };

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {
      bar = {
        density = "default";
        position = "top";
        shrightowCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = false;
            }
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          center = [
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
          right = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "Sussex, United States";
      };
    };
  };

  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "/home/vinnie/Pictures/Wallpapers/pre-productive.jpg";
    };
  };
}
