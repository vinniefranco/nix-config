{ config, pkgs, ... }:

{
  boot.tmp.cleanOnBoot = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

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
    networkmanager.enable = true;
  };

  security.polkit.enable = true;

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

  boot.kernel.sysctl = {
    ## TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # Do not accept IP source route packets (we're not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Don't send ICMP redirects (again, we're not a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Protects against SYN flood attacks
    "net.ipv4.tcp_syncookies" = 1;
    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;

    ## TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
  };

  boot.kernelModules = [ "tcp_bbr" ];
  security = {
    # allow wayland lockers to unlock the screen
    pam = {
      services.hyprlock = {
        text = "auth include login";
        fprintAuth = if config.networking.hostName == "v3" then true else false;
      };
      loginLimits = [
        {
          domain = "@users";
          item = "rtprio";
          type = "-";
          value = 1;
        }
      ];
    };
    # userland niceness
    rtkit.enable = true;

    # don't ask for password for wheel group
    sudo.wheelNeedsPassword = false;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    bat
    direnv
    eza
    fzf
    git
    git-lfs
    kicad
    kicadAddons.kikit
    kikit
    killall
    kitty
    libnotify
    libqalculate
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    lm_sensors
    neovim
    nixfmt-rfc-style
    nss.tools
    pciutils
    pulseaudio
    spice
    spice-gtk
    spice-protocol
    swaynotificationcenter
    tela-circle-icon-theme
    tldr
    traceroute
    unzip
    usbutils
    v4l-utils
    virt-manager
    virt-viewer
    vulkan-tools
    wget
    win-spice
    win-virtio
    wl-clipboard
  ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;

  # Automounts
  services.devmon.enable = true;
  services.udisks2.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  # I use ZSH, btw.
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome.gnome-settings-daemon
    ];
    dbus.implementation = "broker";
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  # For zee secrets
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

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  services.xserver.enable = true;
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "${import ../common/sddm/sddm-chilli.nix { inherit pkgs; }}";
    };
    sessionPackages = [ pkgs.hyprland ];
  };
}
