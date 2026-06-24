{ config, pkgs, ... }:

let
  # Papirus with Catppuccin Mocha folders — matches noctalia's builtin scheme
  # and is what fuzzel already references (fuzzel.nix).
  papirus = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "blue";
  };
  cursorTheme = "catppuccin-mocha-dark-cursors";
  cursorPkg = pkgs.catppuccin-cursors.mochaDark;
in
{
  imports = [
    ./fuzzel.nix
    ./niri.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    adw-gtk3 # GTK theme noctalia's gtk template recolors
    brightnessctl
    ddcutil
    google-chrome
    gparted
    hyprsunset
    networkmanagerapplet
    papirus
    pavucontrol
    libsForQt5.qt5ct
    kdePackages.qt6ct
    slack
    swaybg
    vesktop
    vivaldi
    vivaldi-ffmpeg-codecs
    wf-recorder
    wl-screenrec
  ];

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = cursorTheme;
    size = 32;
    package = cursorPkg;
  };

  home.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    DEFAULT_BROWSER = "${pkgs.lib.getExe pkgs.firefox}";
    DISPLAY = ":0";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct"; # noctalia's qt template feeds qt6ct/qt5ct
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };

  # GTK dark theme. adw-gtk3-dark is the base theme; noctalia's gtk3/gtk4
  # templates inject the exact Catppuccin palette via an @import in gtk.css.
  gtk.enable = true;
  gtk.theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };
  gtk.iconTheme = {
    name = "Papirus-Dark";
    package = papirus;
  };
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };
  # GTK4/libadwaita ignores themes; noctalia themes it via gtk-4.0/gtk.css.
  gtk.gtk4.theme = null;

  # Point qt6ct/qt5ct at the color scheme noctalia's qt template generates,
  # so Qt apps follow the same palette. The colors/noctalia.conf file is
  # written by noctalia at runtime.
  xdg.configFile = {
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      style=Fusion
      custom_palette=true
      color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf
      icon_theme=Papirus-Dark
    '';
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      style=Fusion
      custom_palette=true
      color_scheme_path=${config.home.homeDirectory}/.config/qt5ct/colors/noctalia.conf
      icon_theme=Papirus-Dark
    '';
  };
}
