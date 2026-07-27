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
    inputs.baud.packages.${pkgs.stdenv.hostPlatform.system}.default
    bat
    bear
    caligula
    clamav
    clamtk
    deadnix
    direnv
    evince
    eza
    file-roller
    ffmpeg-full
    fzf
    ghostty
    git
    git-lfs
    gphoto2
    gpu-screen-recorder
    jq
    handy
    herdr
    killall
    libnotify
    libqalculate
    lm_sensors
    neovim
    nixfmt-tree
    opencode
    eslint
    nss.tools
    pciutils
    pi-coding-agent
    pulseaudio
    playerctl
    python3
    quickshell
    kdePackages.skanpage
    shotcut
    statix
    swayimg
    tldr
    traceroute
    tailscale
    unzip
    usbutils
    v4l-utils
    vulkan-tools
    wget
    wl-clipboard
    wtype # Handy pastes transcripts with this on Wayland; without it, it falls back to X11 typing
    xwayland-satellite
    zmk-studio
  ];

  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  # System-wide shell needs to be enabled
  programs.zsh.enable = true;
}
