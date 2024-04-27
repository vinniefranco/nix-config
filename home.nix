{
  pkgs,
  inputs,
  lib,
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
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    btop
    discord
    fd
    gdk
    gimp
    gnome.file-roller
    htop
    hyprpaper
    lexical
    moonlight-qt
    neofetch
    networkmanagerapplet
    obsidian
    pavucontrol
    pgcli
    pika-backup
    quickemu
    ripgrep
    xorg.xhost
  ];

  home.file = {
    ".config/swaync".source = ./apps/config/swaync;
    ".config/hypr/hyprpaper.conf".source = ./apps/config/hyprpaper.conf;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
}
