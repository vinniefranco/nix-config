{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.expert-ls.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    bat
    bear
    caligula
    clamav
    clamtk
    direnv
    eza
    file-roller
    ffmpeg-full
    fzf
    ghostty
    google-chrome
    git
    git-lfs
    gphoto2
    jq
    inkscape
    killall
    libnotify
    libqalculate
    lm_sensors
    neovim
    nixfmt
    nixfmt-tree
    nodePackages.eslint
    nss.tools
    pciutils
    pulseaudio
    playerctl
    python3
    quickshell
    silver-searcher
    kdePackages.skanpage
    swayimg
    tldr
    traceroute
    tailscale
    unzip
    usbutils
    v4l-utils
    vivaldi
    vivaldi-ffmpeg-codecs
    vulkan-tools
    wget
    wl-clipboard
    xwayland-satellite
  ];

  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  # System-wide shell needs to be enabled
  programs.zsh.enable = true;
}
