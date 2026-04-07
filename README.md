# dotfiles

NixOS flake-based system and home configuration for a development workstation.

## Overview

This repository declaratively manages a full NixOS system ("v3") using flakes and home-manager. It covers everything from kernel parameters and hardware drivers to shell aliases and window manager keybindings.

### Hardware

- AMD CPU with custom microcode (ucodenix)
- AMD GPU with ROCm compute support
- Dual display: laptop (2560x1600) + external 4K (3840x2160)
- QMK mechanical keyboard support
- Btrfs filesystem with subvolumes

### Desktop

- **Window manager:** Niri (scrollable tiling Wayland compositor)
- **Shell panel:** Noctalia (top bar with system widgets)
- **Launcher:** Fuzzel
- **Terminal:** Ghostty, Kitty
- **Theme:** Catppuccin with custom Starship prompt colors

### Development

- Neovim (via a separate [nixvim-config](https://github.com/vinniefranco) flake)
- Languages: Elixir, Rust, C, Node.js, Python
- Git with rebase workflow, LFS enabled
- Docker, libvirtd/QEMU/KVM with VFIO GPU passthrough
- Secrets managed through sops-nix with age encryption

### Audio

- PipeWire with ALSA, PulseAudio, and JACK support
- Real-time kernel parameters and PAM limits for the audio group

## Structure

```
.
├── flake.nix              # Flake definition (inputs, outputs, overlays)
├── hosts/
│   └── v3/                # Host-specific NixOS config and hardware
├── system/                # System-level modules
│   ├── audio.nix          # PipeWire and real-time audio
│   ├── bluetooth.nix
│   ├── desktop.nix        # Niri, GDM, Thunar, dconf
│   ├── docker.nix
│   ├── fonts.nix          # Nerd fonts, Noto, CJK
│   ├── networking.nix     # NetworkManager, Tailscale, Samba, firewall
│   ├── nix.nix            # Nix daemon and store settings
│   ├── packages.nix       # System-wide packages
│   ├── security.nix       # Sudo, PAM limits, polkit, TCP hardening
│   └── vm.nix             # libvirtd, QEMU, VFIO passthrough
├── home/                  # Home-manager configuration
│   ├── default.nix        # Entry point, session variables
│   ├── desktop/           # Niri, Noctalia, GTK, cursor, wallpaper
│   ├── terminal/          # Zsh, Starship, tmux, Atuin, zoxide
│   ├── dev/               # Git, language tooling, editor config
│   └── media/             # Spotify, browsers, creative apps
├── overlays/              # Nixpkgs overlays
└── pkgs/                  # Custom package definitions
```

## Usage

Rebuild the system:

```sh
sudo nixos-rebuild switch --flake .#v3
```

Or use the built-in alias:

```sh
r-s   # nixos-rebuild switch --flake ~/.dotfiles#v3
```

Format nix files:

```sh
nix fmt
```

## Flake Inputs

| Input | Description |
|-------|-------------|
| nixpkgs | nixos-unstable channel |
| home-manager | Declarative user environment management |
| niri | Wayland scrollable tiling compositor |
| noctalia | Shell/panel components for niri |
| nixvim-config | Neovim configuration flake |
| zen-browser | Zen browser package |
| expert-ls | Elixir language server tooling |
| ucodenix | AMD CPU microcode updates |
| sops-nix | Secrets management with age encryption |
| nix-secrets | Private secrets repository (git+ssh) |

## Notable Choices

- **Wayland-first.** Session variables force Wayland for Qt, Electron, and Firefox. XWayland is available as a fallback.
- **Modern CLI replacements.** Standard tools are aliased: `cat` to bat, `find` to fd, `grep` to ripgrep, `tree` to eza.
- **Rebase-only git.** Pull is configured to rebase rather than merge.
- **TCP BBR.** Congestion control is set to BBR for better throughput.
- **Firewall on.** Open ports are limited to HTTP/HTTPS, Spotify Connect, and mDNS.
