{ config, pkgs, ... }:
{
  boot.tmp.cleanOnBoot = true;

  nix = {
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  # Enable networking
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
      trustedInterfaces = [ "virbr0" ];
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
  # Enable sound with pipewire.
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

  xdg = {
    portal = {
      enable = true;
      config = {
        common = {
          default = [
            "wlr"
            "gtk"
          ];
          hyprland = [
            "wlr"
            "gtk"
          ];
        };
      };
      wlr = {
        enable = true;
        settings = {
          screencast = {
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -ro";
          };
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
    };
  };

  boot.kernelModules = [ "tcp_bbr" ];
  security = {
    # allow wayland lockers to unlock the screen
    pam = {
      services = {
        hyprlock = {
          text = "auth include login";
          fprintAuth = if config.networking.hostName == "v3" then true else false;
        };
        sddm = {
          text = ''
            auth 			sufficient  	pam_fprintd.so
          '';
        };
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.chromium.enableWideVine = true;
  environment.systemPackages = with pkgs; [
    bat
    bear
    unstable.bitwig-studio
    caligula
    direnv
    eza
    unstable.freecad-wayland
    ffmpeg-full
    fzf
    git
    git-lfs
    jq
    killall
    (kicad.override {
      addons = [
        pkgs.kicadAddons.kikit
        pkgs.kicadAddons.kikit-library
      ];
    })
    kikit
    kitty
    libnotify
    libqalculate
    unstable.libsForQt5.qt5.qtgraphicaleffects
    unstable.libsForQt5.qt5.qtquickcontrols2
    unstable.libsForQt5.qt5.qtvirtualkeyboard
    lm_sensors
    neovim
    nomachine-client
    nodePackages.eslint
    nixfmt-rfc-style
    nss.tools
    pciutils
    pulseaudio
    silver-searcher
    qmk
    spice
    spice-gtk
    spice-protocol
    swaynotificationcenter
    tldr
    teensy-loader-cli
    traceroute
    tytools
    unzip
    usbutils
    via
    v4l-utils
    vulkan-tools
    wget
    widevine-cdm
    wl-clipboard
  ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;

  hardware.keyboard.qmk.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  # I use ZSH, btw.
  environment.shells = with pkgs; [
    zsh
    bashInteractive
  ];
  programs.zsh.enable = true;

  services = {
    samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    blueman.enable = true;

    gvfs = {
      enable = true;
      package = pkgs.lib.mkForce pkgs.gnome3.gvfs;
    };
    # Automounts
    devmon.enable = true;
    udisks2.enable = true;

    udev.packages = [ pkgs.via ];

    xserver.enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = true;
      };
      sessionPackages = [ pkgs.unstable.hyprland ];
    };
    desktopManager.plasma6.enable = true;
  };

  programs = {
    # dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-dropbox-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };
}
