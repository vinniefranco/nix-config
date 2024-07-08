{ config, pkgs, ... }:
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

  stylix = {
    autoEnable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-dark.yaml";
    image = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/9d/wallhaven-9dpxew.jpg";
      sha256 = "03sag4hsp2kvkim5l5msisj8bn5i46agcmmsgq6dqim0v4sjxn5p";
    };
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "FiraCode Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerdfonts;
        name = "Ubuntu Nerd Font";
      };
      sizes = {
        terminal = 10;
        applications = 11;
        popups = 11;
      };
    };
    opacity = {
      desktop = 0.8;
      terminal = 0.8;
    };
  };

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
    elastic
    fd
    gdk
    gimp
    gnome-themes-extra
    gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.extension-list
    gnomeExtensions.forge
    gnomeExtensions.gsconnect
    gnomeExtensions.just-perfection
    gnomeExtensions.vitals
    gnomeExtensions.workspace-indicator-2
    htop
    kooha
    lexical
    libreoffice
    moonlight-qt
    neofetch
    networkmanagerapplet
    obsidian
    pgcli
    pika-backup
    quickemu
    ripgrep
    switcheroo
    tangram
    xorg.xhost
  ];

  home.file = {
    # ".config/swaync".source = ./apps/config/swaync;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          dash-to-dock.extensionUuid
          gsconnect.extensionUuid
          just-perfection.extensionUuid
          forge.extensionUuid
          vitals.extensionUuid
          caffeine.extensionUuid
          workspace-indicator-2.extensionUuid
        ];
      };
      "org/gnome/desktop/interface" = {
        # Use dconf-editor to get this settings.
        color-scheme = "prefer-dark";
        cursor-theme = config.stylix.cursor.name;
        cursor-size = config.stylix.cursor.size;
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
}
