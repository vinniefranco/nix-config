{ pkgs, ... }:

{
  qt.enable = true;
  qt.platformTheme.name = "gtk";

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 24;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-size = 24;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "slight";
      gtk-xft-antialias = 1; # => font-antialiasing="grayscale"
      gtk-xft-rgba = "rgb"; # => font-rgb-order="rgb"
    };
  };
}
