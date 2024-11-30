{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono NFM:size=10";
        layer = "overlay";
        line-height = "16";
        terminal = "${pkgs.kitty}/bin/kitty";
        horizontal-pad = 40;
        vertical-pad = 40;
        icon-theme = "Papirus";
      };
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-match = "f38ba8ff";
        selection-text = "cdd6f4ff";
        border = "b4befeff";
      };
    };
  };
}
