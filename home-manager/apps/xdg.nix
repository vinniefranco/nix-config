{ pkgs, pkgs-unstable, ... }:

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
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/xhtml_xml" = [ "firefox.desktop" ];
      };
    };
    userDirs.enable = true;
  };
}
