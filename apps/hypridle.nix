{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = with pkgs-unstable; [ hypridle ];

  home.file = {
    ".config/hypr/hypridle.conf" = {
      text = ''
        general {
          lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
          ignore_dbus_inhibit = false
          before_sleep_cmd = loginctl lock-session    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
        }

        # Screenlock
        listener {
          timeout = 600
          on-timeout = loginctl lock-session          # lock screen when timeout has passed
          on-resume = ${pkgs.libnotify}/bin/notify-send "Welcome back ${config.home.username}!"
        }
      '';
    };
  };
}
