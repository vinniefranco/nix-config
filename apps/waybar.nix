{ pkgs-unstable, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs-unstable.waybar;
    style = ''

      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0.5);
        border-bottom: 1px solid @unfocused_borders;
        color: white;
      }

      #window {
        font-weight: bold;
        font-family: "JetBrainsMono Nerd Font";
      }

      #workspaces button {
        padding: 0 10px;
        background: transparent;
        color: white;
        border-top: 2px solid transparent;
      }

      #workspaces button.focused {
        color: #00e8c6;
        border-top: 2px solid #00e8c6;
      }

      #workspaces button.active {
        color: #00e8c6;
        border-top: 2px solid #00e8c6;
      }

      #mode {
        background: #64727d;
        border-bottom: 3px solid white;
      }

      #clock,
      #battery,
      #disk,
      #cpu,
      #custom-weather,
      #custom-caffeine,
      #custom-updates,
      #custom-notification,
      #idle_inhibitor,
      #backlight,
      #memory,
      #network,
      #pulseaudio,
      #custom-spotify,
      #tray,
      #mode {
        padding: 0 5px;
        margin: 0 2px;
      }

      #clock {
        margin-left: 10px;
      }

      #battery {}

      #battery icon {
        color: red;
      }

      #battery.charging {}

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

      #cpu {}

      #memory {}

      #network {}

      #network.disconnected {
        background: #f53c3c;
      }

      #pulseaudio {}

      #pulseaudio.muted {}

      #custom-updates {
        padding: 0 4px 0 10px;
      }

      #custom-notification {
        padding: 0 4px 0 10px;
      }

      #tray {
        margin-right: 10px;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        height = 38;
        exclusive = true;
        gtk-layer-shell = true;
        passthrough = false;
        position = "top";
        spacing = 4;
        ipc = false;
        tray.spacing = 4;
        modules-left = [
          "hyprland/workspaces"
          "clock"
          "sway/mode"
          "cpu"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "custom/notification"
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
          "battery"
          "network"
          "tray"
        ];

        # Notifications
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        backlight = {
          interval = 2;
          format = "{icon} {percent}%";
          format-icons = [
            "󱩎"
            "󱩐"
            "󱩐"
            "󱩒"
            "󱩒"
            "󱩔"
            "󱩖"
          ];
          on-scroll-up = "light -A 5";
          on-scroll-down = "light -U 5";
          smooth-scrolling-threshold = 1;
        };

        battery = {
          interval = 60;
          full-at = 100;
          design-capacity = false;
          states = {
            good = 95;
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}% {power}W";
          format-plugged = "ﮣ {capacity}";
          format-full = "󰁹 100%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
          ];
          format-time = "{H}h {M}min";
          tooltip = true;
          tooltip-format = "{power} {timeTo}";
        };

        clock = {
          format = " {:%r    %a %d/%m}";
          timezone = "America/Chicago";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        cpu = {
          interval = 10;
          format = " {usage}%";
          max-length = 10;
        };

        network = {
          interval = 5;
          #"interface": "wlan*", // (Optional) To force the use of this interface, set it for netspeed to work
          format-icons = [
            "󰣾"
            "󰣴"
            "󰣶"
            "󰣸"
            "󰣺"
          ];
          format-wifi = "{icon} {essid}";
          format-ethernet = "󰈀";
          format-linked = "󱛆";
          format-disconnected = "󰤦";
          format-disabled = "󰤭";
          format-alt = " {bandwidthUpBits} |  {bandwidthDownBits}";
          tooltip-format = "󰖩 {ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid}({signalStrength}%) |  {bandwidthUpBytes}  {bandwidthDownBytes}";
          on-click = "[[ ! `pidof nm-connection-editor` ]] && nm-connection-editor || pkill nm-connection-e";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-bluetooth = "󰦢 {volume}%";
          format-bluetooth-muted = "󰗿";
          format-source = "󰓃";
          format-source-muted = "󰓄";
          format-icons = {
            headphone = "";
            hands-free = "ﳌ";
            headset = "";
            phone = "";
            portable = "󰲑";
            car = "󰄋";
            default = [
              ""
              ""
              ""
            ];
          };
          scroll-step = 5.0;
          #/ Commands to execute on events
          on-click = "amixer set Master toggle";
          on-click-right = "pavucontrol";
          smooth-scrolling-threshold = 1;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "hyprland/window" = {
          format = "󱢶 {} 󰩔";
          rewrite = {
            "(.*) - Chromium" = "󰖟 $1";
            "(.*) - zsh" = " [$1]";
          };
          separate-outputs = true;
        };

        "hyprland/workspaces" = {
          persistent_workspaces = {
            "1" = [ "DP-3" ];
            "2" = [ "DP-3" ];
            "3" = [ "DP-3" ];
            "4" = [ "eDP-1" ];
            "5" = [ "eDP-1" ];
            "6" = [ "eDP-1" ];
            "7" = [ "DP-2" ];
          };
          disable-scroll = false;
          disable-click = false;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "󰧑";
            "3" = "";
            "4" = "";
            "5" = "󰊕";
            "6" = "󰯜";
            "7" = "";
            "8" = "";
            "9" = "";
            urgent = "";
            default = "";
          };
          smooth-scrolling-threshold = 1;
          disable-scroll-wraparound = false;
          enable-bar-scroll = false;
          disable-markup = false;
          current-only = false;
        };
      };
    };
  };
}
