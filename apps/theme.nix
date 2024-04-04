{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Sweet-Dark";
      package = pkgs.arc-theme;
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Adwaita";
      size = 24;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application--prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application--prefer-dark-theme=1
      '';
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };
}
