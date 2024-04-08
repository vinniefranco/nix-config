{ lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
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
        modules-left = [ "sway/workspaces" "clock" "sway/mode" "cpu" ];
        modules-center = [ "sway/window" ];
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
            inhibited-notification =
              "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification =
              "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "backlight" = {
          interval = 2;
          format = "{icon} {percent}%";
          format-icons = [ "󱩎" "󱩐" "󱩐" "󱩒" "󱩒" "󱩔" "󱩖" ];
          on-scroll-up = "light -A 5";
          on-scroll-down = "light -U 5";
          smooth-scrolling-threshold = 1;
        };

        "battery" = {
          interval = 60;
          full-at = 100;
          design-capacity = false;
          states = {
            good = 95;
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄";
          format-plugged = "ﮣ";
          format-full = "󰁹 100%";
          format-icons = [ "󰂎" "󰁺" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
          format-time = "{H}h {M}min";
          tooltip = true;
          tooltip-format = "{power} {timeTo}";
        };

        "clock" = {
          format = " {:%R    %d/%m}";
          timezone = "America/Chicago";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "cpu" = {
          interval = 10;
          format = " {avg_frequency}GHz";
          max-length = 10;
        };
        "network" = {
          interval = 5;
          #"interface": "wlan*", // (Optional) To force the use of this interface, set it for netspeed to work
          format-icons = [ "󰣾" "󰣴" "󰣶" "󰣸" "󰣺" ];
          format-wifi = "{icon} {essid}";
          format-ethernet = "󰈀";
          format-linked = "󱛆";
          format-disconnected = "󰤦";
          format-disabled = "󰤭";
          format-alt = " {bandwidthUpBits} |  {bandwidthDownBits}";
          tooltip-format = "󰖩 {ifname} via {gwaddr}";
          tooltip-format-wifi =
            "{essid}({signalStrength}%) |  {bandwidthUpBytes}  {bandwidthDownBytes}";
          on-click =
            "[[ ! `pidof nm-connection-editor` ]] && nm-connection-editor || pkill nm-connection-e";
        };

        "pulseaudio" = {
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
            default = [ "" "" "" ];
          };
          scroll-step = 5.0;
          #/ Commands to execute on events
          on-click = "amixer set Master toggle";
          on-click-right = "pavucontrol";
          smooth-scrolling-threshold = 1;
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "sway/window" = {
          format = "{app_id}";
          max-length = 15;
        };

        "sway/workspaces" = {
          persistent_workspaces = {
            "1" = [ "DP-2" ];
            "2" = [ "DP-2" ];
            "3" = [ "DP-2" ];
            "4" = [ "eDP-1" ];
            "5" = [ "eDP-1" ];
            "6" = [ "eDP-1" ];
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
    style = ./config/waybar/style.css;
  };
}
