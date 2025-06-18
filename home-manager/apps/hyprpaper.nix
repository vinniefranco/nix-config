{ pkgs, ... }:
let
  v3_image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/ly/wallhaven-ly95v2.jpg";
    sha256 = "07ndns085zkxdclfjz1if0var95pvisvl7b6hsqhfx496vadmpnw";
  };
in
{

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        v3_image
      ];

      wallpaper = [
        "DP-3,${v3_image}"
        "DP-2,${v3_image}"
        "eDP-1,${v3_image}"
      ];
    };
  };
}
