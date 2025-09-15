# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  outputs,
  pkgs,
  ...
}:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
      kubectl
    ]
  );
in
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
      "microcode.amd_sha_check=off"
      "boot.shell_on_fail"
    ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.enable = false;
    };
    plymouth = {
      enable = true;
      theme = "hexagon_dots";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override { selected_themes = [ "hexagon_dots" ]; })
      ];
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    "f /dev/shm/looking-glass 0660 vinnie qemu-libvirtd -"
  ];
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
  services.pulseaudio.enable = false;
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
      "camera"
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
    shell = pkgs.nushell;
    packages = with pkgs; [
      ddcutil
      gparted
      firefox
      light
      slack
      spotify
    ];
  };

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  environment.systemPackages = [
    gdk
  ];

  hardware.i2c.enable = true;

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
    enable = false;
    permitCertUid = "vinnie";
    extraUpFlags = [ "--accept-routes" ];
  };

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A70F52";
  };

  services.fstrim.enable = true;
  services.fprintd.enable = true;
  system.stateVersion = "25.11"; # Did you read the comment?
}
