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
    ../../system/maintenance.nix
    ../../system/networking.nix
    ../../system/nix.nix
    ../../system/packages.nix
    ../../system/security.nix
    ../../system/vm.nix
    inputs.ucodenix.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.niri.overlays.niri
    ];
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
    # Emulate aarch64 so the rock5b host can be built/tested from this machine.
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
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

  # Sudo via the fingerprint reader, with the login password as fallback.
  # (Replaces the previous passwordless-wheel policy.) fprintAuth defaults on
  # whenever fprintd is enabled; the meaningful change is requiring auth at all.
  security.sudo.wheelNeedsPassword = true;
  security.pam.services.sudo.fprintAuth = true;

  # Fingerprint-or-password on the Noctalia lock screen. Noctalia tries the
  # "noctalia" PAM service first (then falls back to "login"); defining it here
  # gives the lock its own minimal stack: fprintd (sufficient) -> password.
  security.pam.services.noctalia.fprintAuth = true;

  # Don't put fprintd in the greeter's auth stack. Enabling services.fprintd
  # turns fprintAuth on for every auto-generated PAM service, including greetd.
  # noctalia-greeter submits a password, but pam_fprintd (sufficient, first in
  # the stack) blocks waiting for a finger swipe and only falls through to the
  # password after its ~30s timeout — that's the freeze after hitting submit.
  security.pam.services.greetd.fprintAuth = false;

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
  };

  # Enabling the module (rather than installing the bare package) is what makes
  # the preferences below actually take effect.
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.gtk.libadwaita-colors.enabled" = false;
    };
  };

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = [
    gdk
  ];

  system.stateVersion = "25.11";
}
