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
    xdg-user-dirs
  ];

  xdg = {
    enable = true;
    configFile."electron-flags.conf".source = ./config/electron-apps.conf;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/xhtml_xml" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "default-web-browser" = [ "firefox.desktop" ];
      };
    };
    userDirs.enable = true;
  };
}
