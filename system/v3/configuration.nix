# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/fonts.nix
    ../common/vm.nix
    inputs.ucodenix.nixosModules.default
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Bootloader.
  boot = {
    initrd.verbose = false;
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "amd_pstate=guided"
      "rd.systemd.show_status=false"
      "boot.shell_on_fail"
    ];
    kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0660 vinnie qemu-libvirtd -" ];
  powerManagement.enable = true;

  networking.hostName = "v3"; # Define your hostname.

  # Networking
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
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
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

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
      "dialout"
      "disk"
      "docker"
      "input"
      "libvirtd"
      "lp"
      "networkmanager"
      "plugdev"
      "scanner"
      "video"
      "wheel"
    ];
    shell = pkgs.unstable.nushell;
    packages = with pkgs; [
      light
      unstable.slack
      unstable.spotify
      unstable.firefox
    ];
  };

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      libvdpau-va-gl
      vaapiVdpau
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  services.hardware.bolt.enable = true;

  services.xserver.videoDrivers = [
    "modesetting"
  ];
  services.tailscale = {
    enable = true;
    permitCertUid = "vinnie";
    extraUpFlags = [ "--accept-routes" ];
  };

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A70F52";
  };

  services.fstrim.enable = true;
  services.fprintd.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
