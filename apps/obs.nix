{ pkgs, ... }:

{
  home.packages = with pkgs; [
    obs-studio
    obs-studio-plugins.obs-gstreamer
    obs-studio-plugins.obs-mute-filter
    obs-studio-plugins.wlrobs
  ];
}
