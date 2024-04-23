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

  powerManagement = {
    enable = true;
  };

  # Virtualization
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;

  # Enable networking
  networking.hostName = "surface"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vinnie = {
    isNormalUser = true;
    description = "Vincent Franco";
    extraGroups = [
      "audio"
      "docker"
      "libvirtd"
      "networkmanager"
      "video"
      "wheel"
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
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    prime = {
      sync.enable = true;
      allowExternalGpu = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:125:0:0";
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # 12th Gen Intel fun
  services.fstrim.enable = true;# Just set the console font, don't mess with the font settings
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  console.earlySetup = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
