{ ... }:

{
  programs.kitty = {
    enable = true;
    theme = "Square";
    settings = {
      enable_audio_bell = "no";
      window_margin_width = 6;
      hide_window_decorations = "yes";
    };
  };
}
