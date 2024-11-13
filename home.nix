{
  inputs,
  pkgs,
  pkgs-unstable,
  system,
  ...
}:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
      kubectl
    ]
  );
in
{
  imports = [ ./apps ];
  home.username = "vinnie";
  home.homeDirectory = "/home/vinnie";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    inputs.nixvim-config.packages.${system}.default
    inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
    btop
    pkgs-unstable.discord
    fd
    gdk
    gimp
    htop
    httpie
    kooha
    lexical
    libreoffice
    neofetch
    networkmanagerapplet
    pkgs-unstable.obsidian
    open-webui
    pavucontrol
    pgcli
    pika-backup
    ranger
    ripgrep
    pkgs-unstable.vivaldi
    pkgs-unstable.vivaldi-ffmpeg-codecs
    pkgs-unstable.wf-recorder
    pkgs-unstable.xorg.xhost
  ];

  home.file = {
    ".config/swaync".source = ./apps/config/swaync;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    DEFAULT_BROWSER = "${pkgs.chromium}/bin/chromium";
    NIXPKGS_ALLOW_UNFREE = "1";
    HYPRCURSOR_THEME = "McMojave";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
}
