{ ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      prompt = "Apps";
      normal_window = false;
      layer = "top";
      term = "kitty";
      width = "400px";
      height = "305px";
      location = 0;
      orientation = "vertical";
      line_wrap = "off";
      dynamic_lines = false;
      allow_markup = true;
      allow_images = true;
      image_size = 24;
      exec_search = false;
      hide_search = false;
      insensitive = true;
      hide_scroll = true;
      no_actions = true;
      sort_order = "default";
      gtk_dark = true;
      filter_rate = 100;
      key_expand = "Tab";
      key_exit = "Escape";
    };
  };
}
