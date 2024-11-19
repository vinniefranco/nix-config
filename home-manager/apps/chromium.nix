{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
    extensions = [
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa"
      "oldceeleldhonbafppcapldpdifcinji"
    ];
  };
}
