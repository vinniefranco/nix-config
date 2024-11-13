{ pkgs-unstable, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs-unstable.chromium;
    extensions = [
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa"
      "oldceeleldhonbafppcapldpdifcinji"
    ];
  };
}
