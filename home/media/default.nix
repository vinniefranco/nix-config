{ pkgs, ... }:

{
  imports = [
    ./spotify.nix
  ];

  home.packages = with pkgs; [
    mpv
    spotify
    vlc
  ];
}
