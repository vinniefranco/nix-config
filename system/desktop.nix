{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  hardware.keyboard.qmk.enable = true;

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

    thunar = with pkgs.xfce; {
      enable = true;
      plugins = [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    xfconf.enable = true;
    gphoto2.enable = true;
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

    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

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
        via
        vial
      ];
    };

    xserver.enable = true;
    system76-scheduler.enable = true;
  };
}
