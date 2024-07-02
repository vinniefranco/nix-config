{ pkgs, ... }:

{
  home.packages = with pkgs; [
    satty
    sweet
    xdg-user-dirs
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    portal = {
      config = {
        common = {
          default = [
            "gnome"
          ];
        };
      };
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
      ];
    };
    userDirs.enable = true;
  };
}
