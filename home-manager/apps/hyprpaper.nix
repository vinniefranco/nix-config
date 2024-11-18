{ ... }:
let
  image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/yx/wallhaven-yxdrex.png";
    sha256 = "1ym3ch70ss7767rw4j0xyq856s2q656c6n7d40d8c7vjlww4ifll";
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
