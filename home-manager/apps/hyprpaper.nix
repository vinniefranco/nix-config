{ pkgs, ... }:
let
  image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/v9/wallhaven-v9x6gm.jpg";
    sha256 = "14csjsx0lbvq9pb8nn6w07awrp3xfpmcpr7wn8xa5q5hix5swgns";
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
