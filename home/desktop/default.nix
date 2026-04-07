{ pkgs, ... }:

{
  imports = [
    ./fuzzel.nix
    ./niri.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    hyprsunset
    networkmanagerapplet
    pavucontrol
    swaybg
    vesktop
    wf-recorder
    wl-screenrec
    xorg.xhost
  ];

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Vanilla-DMZ";
    size = 64;
    package = pkgs.vanilla-dmz;
  };

  home.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    DEFAULT_BROWSER = "${pkgs.lib.getExe pkgs.firefox}";
    DISPLAY = ":0";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };

  # GTK dark theme
  gtk.enable = true;
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };
}
