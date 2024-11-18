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
        "x-scheme-handler/http" = [ "chromium.desktop" ];
        "x-scheme-handler/https" = [ "chromium.desktop" ];
        "text/html" = [ "chromium.desktop" ];
        "application/xhtml+xml" = [ "chromium.desktop" ];
        "application/xhtml_xml" = [ "chromium.desktop" ];
      };
    };
    userDirs.enable = true;
  };
}