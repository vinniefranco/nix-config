{ pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    theme = "One Dark";
    font.name = "FiraCodeNFM-Med";
    font.size = 10;
  };
}
