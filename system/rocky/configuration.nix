{ lib, inputs, ... }:

{
  imports = with inputs.rock5b; [
    nixosModules.apply-overlay
    nixosModules.kernel
  ];

  nixpkgs.hostPlatform.system = "aarch64-linux";
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  boot.initrd.availableKernelModules = lib.mkForce [
    "ehci_hcd"
    "ehci_pci"
    "ext2"
    "ext4"
    "hid_apple"
    "hid_cherry"
    "hid_generic"
    "hid_lenovo"
    "hid_logitech_dj"
    "hid_logitech_hidpp"
    "hid_microsoft"
    "hid_roccat"
    "md_mod"
    "mmc_block"
    "ohci_hcd"
    "ohci_pci"
    "raid0"
    "raid1"
    "raid10"
    "raid456"
    "sd_mod"
    "sr_mod"
    "uhci_hcd"
    "usbhid"
    "usbhid"
    "xhci_hcd"
    "xhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_ROOTFS";
    fsType = "ext4";
  };
  swapDevices = [ ];
  networking = {
    hostName = "rocky";
    useDHCP = true;
    networkmanager.enable = true;
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  users.users.root.initialPassword = "root";
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  services.avahi.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
