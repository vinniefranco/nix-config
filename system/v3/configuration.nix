# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/fonts.nix
  ];

  stylix = {
    autoEnable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-dark.yaml";
    image = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/9d/wallhaven-9dpxew.jpg";
      sha256 = "03sag4hsp2kvkim5l5msisj8bn5i46agcmmsgq6dqim0v4sjxn5p";
    };
    targets.plymouth.enable = false;
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "FiraCode Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerdfonts;
        name = "Ubuntu Nerd Font";
      };
      sizes = {
        terminal = 10;
        applications = 11;
        popups = 11;
      };
    };
    opacity = {
      desktop = 0.8;
      terminal = 0.8;
    };
  };

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

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
    };
    sensor.iio.enable = true;
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

  # Networking
  networking.networkmanager.enable = true;

  services = {
    fstrim.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;

    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # Enable CUPS to print documents.
    printing.enable = true;
    tailscale = {
      enable = true;
      permitCertUid = "vinnie";
      extraUpFlags = [ "--accept-routes" ];
    };
    udev.packages = with pkgs; [ via ];
    xserver = {
      videoDrivers = [ "modesetting" ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };

  };
  sound.enable = true;
  security.rtkit.enable = true;

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

  system.stateVersion = "24.05"; # Did you read the comment?
}
