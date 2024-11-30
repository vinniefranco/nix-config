{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.unstable.chromium.override { enableWideVine = true; };
    extensions = [
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa"
      "oldceeleldhonbafppcapldpdifcinji"
    ];
  };
}
