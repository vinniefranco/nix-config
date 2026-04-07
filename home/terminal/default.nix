{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./shell.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    btop
    fd
    htop
    nnn
    ranger
    ripgrep
  ];

  home.file = {
    ".config/ghostty/config".source = ./ghostty.conf;
  };
}
