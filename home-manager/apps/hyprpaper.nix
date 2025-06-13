{ pkgs, ... }:
let
  v3_image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/21/wallhaven-21ke9m.jpg";
    sha256 = "1byadrld1ll9cdqsa6kai2xvp6046wx75gpwxhyxghpdl8h69ig5";
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
