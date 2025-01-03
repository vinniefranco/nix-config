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
      outputs.overlays.additions
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
    unstable.vesktop
    fd
    gdk
    gource
    obs-studio
    gimp
    htop
    krita
    lexical
    libreoffice
    neofetch
    networkmanagerapplet
    unstable.hyprsunset
    orca-slicer
    unstable.obsidian
    open-webui
    pavucontrol
    pgcli
    unstable.pika-backup
    ranger
    ripgrep
    unstable.vivaldi
    unstable.vivaldi-ffmpeg-codecs
    unstable.wf-recorder
    wl-screenrec
    xorg.xhost
  ];

  home.file = {
    ".config/swaync".source = ./apps/config/swaync;
  };

  home.sessionVariables = {
    # ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    DEFAULT_BROWSER = "${pkgs.lib.getExe pkgs.firefox}";
    EDITOR = "nvim";
    # NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
}
