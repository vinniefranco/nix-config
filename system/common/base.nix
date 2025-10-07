{
  config,
  pkgs,
  lib,
  ...
}:
let
  v3_image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/ly/wallhaven-ly95v2.jpg";
    sha256 = "07ndns085zkxdclfjz1if0var95pvisvl7b6hsqhfx496vadmpnw";
  };
in
{
  boot.tmp.cleanOnBoot = true;

  nix = {
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--delete-older-than 7d";
    };
    settings = {
      download-buffer-size = 524288000;
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
        # Spotify and casting devices
        57621
        5353
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
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gnome
      ];
    };
  };

  boot.kernelModules = [ "tcp_bbr" ];

  security = {
    # allow wayland lockers to unlock the screen
    pam = {
      services = {
        hyprlock = {
          text = "auth include login";
          fprintAuth = config.networking.hostName == "v3";
        };
      };
      loginLimits = [
        {
          domain = "@users";
          item = "rtprio";
          type = "-";
          value = 1;
        }
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "soft";
          value = "99999";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "hard";
          value = "99999";
        }
        {
          domain = "*";
          item = "nofile";
          type = "hard";
          value = "1048576";
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
    caligula
    clamav
    clamtk
    direnv
    eza
    file-roller
    ffmpeg-full
    fzf
    ghostty
    git
    git-lfs
    gphoto2
    jq
    killall
    libnotify
    libqalculate
    lm_sensors
    neovim
    nixfmt-rfc-style
    nixfmt-tree
    nodePackages.eslint
    nomachine-client
    nss.tools
    pciutils
    pulseaudio
    python3
    quickshell
    silver-searcher
    spice
    spice-gtk
    spice-protocol
    swaynotificationcenter
    swayimg
    tldr
    traceroute
    unzip
    usbutils
    v4l-utils
    vivaldi
    vivaldi-ffmpeg-codecs
    vulkan-tools
    wget
    wl-clipboard
    xwayland-satellite
  ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;

  hardware.keyboard.qmk.enable = true;

  virtualisation.docker = {
    enable = config.networking.hostName == "v3";
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  environment.shells = with pkgs; [
    bashInteractive
    nushell
  ];

  programs.sway.enable = false;
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  programs.xwayland.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-vcs-plugin
      thunar-volman
    ];
  };

  programs.regreet = {
    enable = true;
    theme = {
      name = "Numix";
      package = pkgs.numix-gtk-theme;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
    };
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
      };
      background = {
        path = v3_image;
        fit = "Contain";
      };
    };
  };

  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryFlavor = "";
  };
  programs.nix-ld.enable = true;

  services = {
    samba = {
      enable = true;
      settings = {
        global.security = "user";
      };
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

    tumbler.enable = true;

    gvfs = {
      enable = true;
      package = pkgs.lib.mkForce pkgs.gnome.gvfs;
    };
    gnome = {
      tinysparql.enable = true;
      gnome-keyring.enable = true;
    };
    dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        gnome-settings-daemon
      ];
    };

    # Automounts
    devmon.enable = true;
    udisks2.enable = true;

    udev = {
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.stdenv.shell} -c 'chgrp video $sys$devpath/brightness'", RUN+="${pkgs.stdenv.shell} -c 'chmod g+w $sys$devpath/brightness'"
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        KERNEL=="i2c-[0-9]*", TAG+="uaccess"
      '';
      packages = with pkgs; [
        openocd
        platformio-core
        via
        vial
      ];
    };

    xserver.enable = true;
    displayManager = {
      defaultSession = "sway";
    };
  };

  programs = {
    xfconf.enable = true;
    gphoto2.enable = true;
  };
}
