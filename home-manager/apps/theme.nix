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
  # xdg.configFile = {
  #   kvantum = {
  #     target = "Kvantum/kvantum.kvconfig";
  #     text = lib.generators.toINI { } {
  #       General.theme = "Catppuccin-Mocha-Blue";
  #     };
  #   };
  #
  #   qt5ct = {
  #     target = "qt5ct/qt5ct.conf";
  #     text = lib.generators.toINI { } {
  #       Appearance = {
  #         icon_theme = "Papirus-Dark";
  #       };
  #     };
  #   };
  #
  #   qt6ct = {
  #     target = "qt6ct/qt6ct.conf";
  #     text = lib.generators.toINI { } {
  #       Appearance = {
  #         icon_theme = "Papirus-Dark";
  #       };
  #     };
  #   };
  # };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      # name = "Bibata-Modern-Classic";
      # package = pkgs.bibata-cursors;
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
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
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
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
    x11.enable = true;
    name = "capitaine-cursors-white";
    package = pkgs.capitaine-cursors;
    size = 30;
  };
}
