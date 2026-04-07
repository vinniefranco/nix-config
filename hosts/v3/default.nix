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
    ./hardware-configuration.nix
    ../../system/audio.nix
    ../../system/bluetooth.nix
    ../../system/desktop.nix
    ../../system/docker.nix
    ../../system/fonts.nix
    ../../system/networking.nix
    ../../system/nix.nix
    ../../system/packages.nix
    ../../system/security.nix
    ../../system/vm.nix
    inputs.ucodenix.nixosModules.default
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.niri.overlays.niri
    ];
    config.allowUnfree = true;
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

  networking.hostName = "v3";
  networking.networkmanager.wifi.powersave = false;
  networking.useNetworkd = false;
  networking.firewall.checkReversePath = "loose";

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

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

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      rocmPackages.clr.icd
    ];
  };

  services.hardware.bolt.enable = true;

  services.xserver.videoDrivers = [
    "modesetting"
  ];
  services.tailscale = {
    enable = true;
    permitCertUid = "vinnie";
    useRoutingFeatures = "client";
    extraUpFlags = [ "--accept-routes" ];
  };

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A70F52";
  };

  services.fstrim.enable = true;
  services.fprintd.enable = true;

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
    shell = pkgs.zsh;
    packages = with pkgs; [
      ddcutil
      gparted
      firefox
      brightnessctl
      slack
      spotify
    ];
  };
  programs.firefox.preferences = {
    "widget.gtk.libadwaita-colors.enabled" = false;
  };

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = [
    gdk
  ];

  system.stateVersion = "25.11";
}
