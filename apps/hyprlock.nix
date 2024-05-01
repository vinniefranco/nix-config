{ config, ... }:

{
  programs.hyprlock = {
    enable = true;

    general = {
      disable_loading_bar = true;
      hide_cursor = false;
    };

    background = [
      {
        monitor = "";
        path = "${config.home.homeDirectory}/Pictures/wallpapers/space-flower.png";
      }
    ];

    input-fields = [
      {
        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 2;
        placeholder_text = ''<span>Password...</span>'';

        dots_spacing = 0.3;
        dots_center = true;
      }
    ];
  };
}
