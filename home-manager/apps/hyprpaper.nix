{ pkgs, ... }:
let
  image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/2k/wallhaven-2k7pv9.jpg";
    sha256 = "1lvnjhijkb5jz378g492s13hdqjr12fwb0bn6wxhnirpagwp445v";
  };
in
{

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ image ];

      wallpaper = [
        "DP-3,${image}"
        "DP-2,${image}"
        "eDP-1,${image}"
      ];
    };
  };
}
