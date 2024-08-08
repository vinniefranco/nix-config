# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/fonts.nix
    inputs.ucodenix.nixosModules.ucodenix
  ];

  # Bootloader.
  boot = {
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
    ];
    kernelPackages = pkgs.linuxPackages_zen;
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
  networking.hostName = "v3"; # Define your hostname.

  # Networking
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing = {
    browsing = true;
    enable = true;
    browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All

      BrowseProtocols all
    '';
    drivers = [ pkgs.hplipWithPlugin ];
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  services.ucodenix = {
    enable = true;
    cpuSerialNumber = "00A7-0F52-0000-0000-0000-0000";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

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

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };

  services.xserver.videoDrivers = [ "modesetting" ];
  services.udev.packages = with pkgs; [ via ];
  services.tailscale = {
    enable = true;
    permitCertUid = "vinnie";
    extraUpFlags = [ "--accept-routes" ];
  };

  services.fstrim.enable = true;
  services.fprintd.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
