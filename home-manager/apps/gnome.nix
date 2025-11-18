{pkgs, lib, ...}:
{
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.brightness-control-using-ddcutil
    gnomeExtensions.caffeine
    gnomeExtensions.tiling-shell
    gnomeExtensions.vitals
    gnomeExtensions.zen
  ];

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
      dynamic-workspaces = true;
      edge-tiling = true;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        caffeine.extensionUuid
        brightness-control-using-ddcutil.extensionUuid
        blur-my-shell.extensionUuid
        tiling-shell.extensionUuid
      ];
    };
    "org/gnome/shell/extensions/display-brightness-ddcutil" = {
      ddcutil-binary-path = lib.getExe pkgs.ddcutil;
      show-value-label = true;
    };
    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = true;
      clock-show-seconds = true;
      color-scheme = "prefer-dark";
      enable-animations = true;
      enable-hot-corners = true;
    };
    "org/gnome/gnome-system-monitor" = {
      show-dependencies = true;
    };
    "org/gnome/system/location" = {
      enabled = true;
    };
    "org/gnome/shell/extensions/tilingshell" = {
      enable-window-border = true;
      window-border-width = lib.hm.gvariant.mkUint32 1;
      window-border-color = "rgb(26,95,180)";

      tiling-system-activation-key = [ "2" ]; # Super
      span-multiple-tiles-activation-key = [ "1" ]; # alt
      tiling-system-deactivation-key = [ "-1" ]; # Disable deactivation

      enable-autotiling = true;
      enable-tiling-system-windows-suggestions = true;
      enable-screen-edges-windows-suggestions = true;
      restore-window-original-size =
        false; # When untitled, don't restore original size
    };
  };
}
