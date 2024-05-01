# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/fonts.nix
  ];

  # Bootloader.
  boot = {
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      theme = "hexagon_dots";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override { selected_themes = [ "hexagon_dots" ]; })
      ];
    };
  };
  networking.hostName = "cubuerto"; # Define your hostname.

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vinnie = {
    isNormalUser = true;
    description = "Vincent Franco";
    extraGroups = [
      "audio"
      "docker"
      "input"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
    ];
    packages = with pkgs; [
      slack
      spotify
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  services.xserver.videoDrivers = [ "modesetting" ];
  services.udev.packages = with pkgs; [ via ];
  system.stateVersion = "24.05"; # Did you read the comment?
}
