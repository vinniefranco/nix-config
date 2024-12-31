{ pkgs, ... }:

{
  qt.enable = true;
  # qt.platformTheme.name = "gtk";

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
    theme = {
      package = pkgs.juno-theme;
      name = "Juno";
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-name=Bibata-Modern-Classic
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-name=Bibata-Modern-Classic
      '';
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        theme = "Juno";
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
}
