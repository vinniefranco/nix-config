{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      accent = "blue";
      variant = "macchiato";
    })
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    papirus-folders
  ];

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "blue";
      };
    };
    theme = {
      package = pkgs.juno-theme;
      name = "Juno";
    };

    gtk3.extraConfig = {
      gtk-cursor-theme-size = 24;
    };

    gtk4.extraConfig = {
      gtk-cursor-theme-size = 24;
    };
  };

  dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
        theme = "Juno";
        color-scheme = "prefer-dark";
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
