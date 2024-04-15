{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/fonts.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.blacklistedKernelModules = [ "nouveau" ];

  boot.plymouth = {
    enable = true;
    theme = "hexagon_dots";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override { selected_themes = [ "hexagon_dots" ]; })
    ];
  };

  # Enable networking
  networking.hostName = "surface"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vinnie = {
    isNormalUser = true;
    description = "Vincent Franco";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "video"
    ];
    packages = with pkgs; [
      slack
      spotify
      firefox
    ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      allowExternalGpu = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:125:0:0";
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
