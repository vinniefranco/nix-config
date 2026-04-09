{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../system/networking.nix
    ../../system/nix.nix
    ../../system/security.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config.allowUnfree = true;
  };

  # Bootloader - extlinux for U-Boot on ARM
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelParams = [
      "console=ttyS2,1500000"
      "earlycon=uart8250,mmio32,0xfeb50000"
    ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  networking.hostName = "rock5b";

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  services.fstrim.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.vinnie = {
    isNormalUser = true;
    description = "Vincent Franco";
    extraGroups = [
      "disk"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here
    ];
  };

  environment.systemPackages = with pkgs; [
    bat
    direnv
    eza
    fzf
    git
    htop
    jq
    neovim
    silver-searcher
    tldr
    traceroute
    unzip
    wget
  ];

  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
