{ pkgs, inputs, lib, ... }:
  let
    gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
      kubectl
    ]);
  in
{
  imports = [ 
    inputs.nix-colors.homeManagerModules.default
    ./apps 
  ];

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
    discord
    fd
    gdk
    networkmanagerapplet
    obsidian
    pavucontrol
    ripgrep
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
  };
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
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
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
