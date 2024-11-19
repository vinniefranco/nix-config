{
  inputs,
  outputs,
  pkgs,
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

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
      chromium = {
        enableWideVine = true;
      };
    };
  };

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
    inputs.nixvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
    btop
    vesktop
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
    obsidian
    open-webui
    pavucontrol
    pgcli
    pika-backup
    ranger
    ripgrep
    vivaldi
    vivaldi-ffmpeg-codecs
    wf-recorder
    xorg.xhost
  ];

  home.file = {
    ".config/swaync".source = ./apps/config/swaync;
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.chromium}/bin/chromium";
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
}
