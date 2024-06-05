{ config, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ config.stylix.image ];

      wallpaper = [
        "DP-3,${config.stylix.image}"
        "DP-2,${config.stylix.image}"
        "eDP-1,${config.stylix.image}"
      ];
    };
  };
}
