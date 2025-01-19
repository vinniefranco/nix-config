{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
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
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    inputs.nixvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
    btop
    vesktop
    fd
    gource
    obs-studio
    gimp
    gcc
    htop
    krita
    lexical
    libreoffice
    neofetch
    nnn
    networkmanagerapplet
    nodePackages.jsonlint
    hyprsunset
    orca-slicer
    obsidian
    open-webui
    pavucontrol
    pgcli
    pika-backup
    ranger
    ripgrep
    wf-recorder
    wl-screenrec
    xorg.xhost
    vial
  ];

  home.file = {
    ".config/swaync".source = ./apps/config/swaync;
    ".config/ghostty/config".source = ./apps/config/ghostty.conf;
  };

  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    DEFAULT_BROWSER = "${pkgs.lib.getExe pkgs.firefox}";
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    STEAM_FORCE_DESKTOPUI_SCALING = "1.6";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
}
