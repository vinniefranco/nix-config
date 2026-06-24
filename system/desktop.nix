{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  # Video thumbnails in Thunar (tumbler picks this up from PATH).
  environment.systemPackages = [ pkgs.ffmpegthumbnailer ];

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld.enable = true;

    niri = {
      enable = true;
      package = pkgs.niri;
    };

    xfconf.enable = true;
    gphoto2.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    noctalia-greeter = {
      enable = true;
      settings.cursor = {
        theme = "catppuccin-mocha-dark-cursors";
        size = 32;
        package = pkgs.catppuccin-cursors.mochaDark;
      };
    };
  };

  services = {
    upower.enable = true;
    tumbler.enable = true;

    gvfs = {
      enable = true;
      package = pkgs.lib.mkForce pkgs.gnome.gvfs;
    };
    gnome = {
      games.enable = false;
      gnome-keyring.enable = true;
      tinysparql.enable = true;
    };

    # greetd is enabled and its session command is set automatically by the
    # noctalia-greeter NixOS module. We only need to point it at the greeter
    # user (auto-created by the greetd module).
    greetd = {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          user = "greeter";
        };
      };
    };

    #desktopManager.gnome.enable = true;
    #displayManager.gdm.enable = true;

    dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
    };

    # Automounts
    devmon.enable = true;
    udisks2.enable = true;

    udev = {
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.stdenv.shell} -c 'chgrp video $sys$devpath/brightness'", RUN+="${pkgs.stdenv.shell} -c 'chmod g+w $sys$devpath/brightness'"
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        KERNEL=="i2c-[0-9]*", TAG+="uaccess"
      '';
      packages = with pkgs; [
        openocd
        platformio-core
      ];
    };

    xserver.enable = true;
    system76-scheduler.enable = true;
  };
}
