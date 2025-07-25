{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: let
  secretspath = builtins.toString inputs.nix-secrets;
in {
  imports = [ ./apps
    inputs.sops-nix.homeManagerModules.sops
  ];

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

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    age.keyFile = "/home/vinnie/.config/sops/age/keys.txt";
    secrets.openrouter_api = {
      path = "%r/openrouter_api.key";
    };
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    inputs.nixvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
    age
    btop
    fd
    gcc
    gimp
    gource
    htop
    hyprsunset
    krita
    lexical
    libreoffice
    networkmanagerapplet
    nnn
    nodePackages.jsonlint
    obsidian
    pavucontrol
    pgcli
    sops
    swaybg
    pika-backup
    ranger
    ripgrep
    unstable.claude-code
    vesktop
    wf-recorder
    wl-screenrec
    xorg.xhost
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
    OPENROUTER_API_KEY = (builtins.readFile "/run/user/1000/openrouter_api.key");
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
}
