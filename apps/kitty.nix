{ pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    theme = "One Dark";
    font.name = "FiraCodeNFM-Med";
    font.size = 10;
    settings = {
      background_opacity = "0.9";
      enable_audio_bell = "no";
      window_margin_width = 6;
    };
  };
}
