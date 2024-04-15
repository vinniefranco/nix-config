{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/fonts.nix
  ];

  # Bootloader.
  boot.tmp.cleanOnBoot = true;
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.polkit.enable = true;
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

  # Enable networking
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
      extraCommands = ''
        iptables -t nat -I OUTPUT 1 -o lo -p tcp --dport 443 -j REDIRECT --to-port 8443
        iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
      '';
    };
    hostName = "surface"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security = {
    rtkit.enable = true;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vinnie = {
    isNormalUser = true;
    description = "Vincent Franco";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "video"
    ];
    packages = with pkgs; [
      slack
      spotify
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    direnv
    git
    git-lfs
    kicad
    kicadAddons.kikit
    kikit
    killall
    kitty
    libnotify
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    neovim
    nixfmt-rfc-style
    nss.tools
    pciutils
    pulseaudio
    swaynotificationcenter
    tela-circle-icon-theme
    traceroute
    unzip
    vulkan-tools
    wget
    wl-clipboard
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      allowExternalGpu = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:125:0:0";
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Automounts
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.light.enable = true;

  # I use ZSH, btw.
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;

  # For zee secrets
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-dropbox-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };

  services.xserver.enable = true;
  services.xserver.displayManager = {
    sddm = {
      enable = true;
      theme = "${import ../common/sddm/sddm-chilli.nix { inherit pkgs; }}";
    };
    sessionPackages = [ pkgs.sway ];
  };

  system.stateVersion = "23.11"; # Did you read the comment?
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
}
