{ inputs, pkgs, lib, ... }:
{

  imports = [inputs.niri.homeModules.niri];

  programs.niri = {
    enable = true;
    config = lib.readFile ./config/niri.kdl;
    package = pkgs.niri;
  };

  programs.waybar = {
    enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
          "DP-2"
        ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "cpu"
          "battery"
          "backlight"
          "clock"
          "tray"
        ];

        "sway/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "";
            "2" = "󰧑";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "󰎛";
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
          persistent-workspaces = {
            "1" = [ "DP-2" ];
            "2" = [ "DP-2" ];
            "3" = [ "DP-2" ];
            "4" = [ "eDP-1" ];
            "5" = [ "eDP-1" ];
            "6" = [ "eDP-1" ];
          };
          sort-by-number = true;
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
          ];
        };

        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
        };

        clock = {
          interval = 60;
          format = "{:%OI:%M %d %h }";
          format-alt = "{:%A, %B %d, %Y (%R)}  ";
          timezone = "America/Chicago";
          max-length = 25;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          interval = 10;
          format = "{}% ";
          max-length = 10;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% ";
          format-muted = "";
          format-icons = {
            "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
          ignored-sinks = [ "Easy Effects Sink" ];
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      .module {
        padding: 0 8px;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0.7);
        color: white;
      }

      #workspaces {}

      #workspaces button {
        padding: 0 10px;
        border-top: 2px solid transparent;
      }

      #workspaces button.focused {
        color: #29e4ad;
        border-bottom: 2px solid #29e4ad;
      }

      #mode {
        background: #64727D;
        border-bottom: 3px solid white;
      }

      #clock, #battery, #cpu, #memory, #network, #battery, #backlight, #tray, #mode {
        margin: 0 2px;
      }

      #clock {
        font-weight: bold;
      }

      #battery {
      }

      #battery icon {
        color: red;
      }

      #battery.charging {
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: black;
        }
      }

      #battery.warning:not(.charging) {
        color: white;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #cpu {
      }

      #memory {
      }

      #network {
      }

      #network.disconnected {
        background: #f53c3c;
      }

      #pulseaudio {
      }

      #pulseaudio.muted {
      }

      #custom-spotify {
        color: rgb(102, 220, 105);
      }

      #tray {
      }

      #pulseaudio-slider slider {
        min-height: 2px;
        min-width: 2px;
        background: #aaaaaa;
        border-radius: 2px;
        border: none;
        box-shadow: none;
      }

      #pulseaudio-slider trough {
        min-height: 5px;
        min-width: 100px;
        border-radius: 5px;
        background: rgba(0, 0, 0, 0.8);
      }

      #pulseaudio-slider highlight {
        min-width: 5px;
        border-radius: 5px;
        background: #ffffff;
      }
    '';
  };
  # home.file.".config/niri/config.kdl".source = pkgs.replaceVars ./config/niri.kdl {
  #   v3_image = "${v3_image}";
  #   DEFAULT_AUDIO_SINK = null;
  #   DEFAULT_AUDIO_SOURCE = null;
  # };

}
