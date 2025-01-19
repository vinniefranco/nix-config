{ pkgs, ... }:
let
  v3_image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/2k/wallhaven-2k7pv9.jpg";
    sha256 = "1lvnjhijkb5jz378g492s13hdqjr12fwb0bn6wxhnirpagwp445v";
  };
  studio_image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/9d/wallhaven-9dqgvk.png";
    sha256 = "1pmcg7ah1nzz6sml3na7156j6s9wpsvvcjiqs6l70hrpmqwnsnl3";
  };
in
{

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        v3_image
        studio_image
      ];

      wallpaper = [
        "DP-3,${v3_image}"
        "DP-2,${v3_image}"
        "DP-1,${studio_image}"
        "eDP-1,${v3_image}"
      ];
    };
  };
}
