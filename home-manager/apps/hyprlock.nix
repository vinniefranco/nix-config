{ config, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        pam_module = "hyprlock";
      };

      backgrounds = [
        {
          path = "${config.home.homeDirectory}/Pictures/wallpapers/space-flower.png";
          blur_passes = 1; # 0 disables blurring
          blur_size = 7;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
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
  };
}
