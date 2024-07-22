{ pkgs, ... }:

let
  screenshoter = import ./screenshoter.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    grim
    satty
    screenshoter
    slurp
    sweet
    xdg-user-dirs
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "chromium.desktop";
        "x-scheme-handler/https" = "chromium.desktop";
      };
    };
    portal = {
      enable = true;
      config = {
        common = {
          default = [
            "wlr"
          ];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    userDirs.enable = true;
  };
}
