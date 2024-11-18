{ ... }:

{
  programs.kitty = {
    enable = true;
    theme = "Square";
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 10;
    };
    settings = {
      background_opacity = "0.8";
      enable_audio_bell = "no";
      window_margin_width = 6;
      hide_window_decorations = "yes";
    };
  };
}
