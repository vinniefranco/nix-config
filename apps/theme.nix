{ pkgs, ... }:

{
  gtk = {
    enable = true;
    # theme = {
    #   name = "Sweet-Dark";
    #   package = pkgs.arc-theme;
    # };
    # cursorTheme = {
    #   name = "WhiteSur-cursors";
    #   size = 24;
    # };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    # gtk3.extraConfig = {
    #   Settings = ''
    #     gtk-application--prefer-dark-theme=1
    #   '';
    # };
    # gtk4.extraConfig = {
    #   Settings = ''
    #     gtk-application--prefer-dark-theme=1
    #   '';
    # };
  };
  #
  # qt = {
  #   enable = true;
  #   platformTheme.name = "gtk";
  # };
  #
  # home.pointerCursor = {
  #   name = "WhiteSur-cursors";
  #   package = pkgs.whitesur-cursors;
  #   size = 24;
  #   x11 = {
  #     enable = true;
  #     defaultCursor = "WhiteSur";
  #   };
  # };
}
