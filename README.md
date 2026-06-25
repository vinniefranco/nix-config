# dotfiles

NixOS flake-based system and [home-manager](https://github.com/nix-community/home-manager)
configuration for a development workstation, plus a headless ARM single-board computer.

## Overview

This repository declaratively manages two machines from a single flake:

| Host     | Arch           | Role                                                              |
|----------|----------------|-------------------------------------------------------------------|
| `v3`     | `x86_64-linux` | Primary AMD laptop/workstation — full desktop, dev, audio, VMs    |
| `rock5b` | `aarch64-linux`| Radxa Rock 5B SBC — headless server (SSH, minimal CLI toolchain)  |

Everything from kernel parameters and hardware drivers down to shell aliases and
window-manager keybindings is managed declaratively. The `v3` host can build and
test the `rock5b` configuration locally via `binfmt` aarch64 emulation.

Binary caches for [nix-community](https://nix-community.cachix.org) and
[noctalia](https://noctalia.cachix.org) are configured in `flake.nix` to avoid
rebuilding from source.

### Hardware (`v3`)

- AMD CPU with custom microcode delivered through [ucodenix](https://github.com/e-tho/ucodenix)
- AMD GPU with ROCm compute (HIP exposed under `/opt/rocm`) and RADV Vulkan
- `linux-zen` kernel with IOMMU / `amd_pstate=guided` boot parameters
- Plymouth boot splash (`hexagon_dots` theme)
- Btrfs root with weekly auto-scrub; zram compressed swap
- Fingerprint reader (`fprintd`), Thunderbolt (`bolt`), I²C/DDC display control
- Printing and scanning (CUPS + Avahi/mDNS, SANE, HP drivers)
- QMK/ZMK keyboard tooling (`zmk-studio`, `openocd`, `platformio`)
- Firmware updates via `fwupd`; power profiles via `power-profiles-daemon`

### Desktop (`v3`)

- **Compositor:** [Niri](https://github.com/YaLTeR/niri) (scrollable-tiling Wayland)
- **Shell/panel:** [Noctalia](https://github.com/noctalia-dev/noctalia)
- **Display manager:** greetd driven by the Noctalia greeter
- **Launcher:** Noctalia (built-in)
- **Terminals:** Ghostty, Kitty
- **File management:** GVfs + Tumbler + udisks2 automounts
- **Theme:** Catppuccin Mocha across GTK, Qt, terminals, tmux, and the Noctalia
  bar (GTK/Qt recolored at runtime from Noctalia's templates); Bibata Modern Ice
  cursor

### Development

- Neovim via the separate [nixvim-config](https://github.com/vinniefranco/nixvim-config) flake
- Languages/tooling: Elixir (with [expert-ls](https://github.com/elixir-lang/expert)),
  Rust, C/C++, Node.js, Python
- `claude-code` and `opencode` AI CLIs (claude-code pinned via an overlay)
- Git with rebase-only pulls, autosquash, rerere, delta diffs, and LFS
- Docker; libvirtd / QEMU / KVM with SPICE and Looking-Glass shared memory
- Secrets via [sops-nix](https://github.com/Mic92/sops-nix) with age encryption,
  sourced from a private `nix-secrets` repo

### Audio (`v3`)

- PipeWire with ALSA (+32-bit), PulseAudio, and JACK
- WirePlumber session manager
- RTKit plus PAM `memlock`/`rtprio`/`nofile` limits for the `audio` group

## Structure

```
.
├── flake.nix              # Inputs, outputs, overlays, nixosConfigurations
├── flake.lock
├── hosts/
│   ├── v3/                # x86_64 workstation host + hardware-configuration
│   └── rock5b/            # aarch64 SBC host + hardware-configuration
├── system/                # System-level NixOS modules
│   ├── audio.nix          # PipeWire + real-time audio limits
│   ├── bluetooth.nix
│   ├── desktop.nix        # Niri, greetd/Noctalia greeter, dbus, udev, file management
│   ├── docker.nix
│   ├── fonts.nix          # Nerd Fonts, Noto, CJK
│   ├── maintenance.nix    # fwupd, power-profiles, zram, btrfs autoScrub
│   ├── networking.nix     # NetworkManager, Samba, firewall, TCP tuning
│   ├── nix.nix            # nh, GC, nix settings, locale, timezone
│   ├── packages.nix       # System-wide packages
│   ├── security.nix       # polkit, PAM limits, passwordless sudo
│   └── vm.nix             # libvirtd, QEMU, SPICE, Looking Glass
├── home/                  # Home-manager configuration
│   ├── default.nix        # Entry point, sops, session vars
│   ├── desktop/           # Niri, XDG, cursor, screenshots
│   ├── terminal/          # Zsh, Starship, tmux, Atuin, zoxide, Ghostty, Kitty
│   ├── dev/               # Git, language/AI tooling
│   └── media/             # Spotify, creative apps
├── overlays/              # nixpkgs overlays (additions + modifications)
└── pkgs/                  # Custom package definitions
```

## Usage

Rebuild a host. This repo uses [`nh`](https://github.com/viperML/nh), which wraps
`nixos-rebuild` with a colorized closure diff and owns automatic GC:

```sh
nh os switch          # rebuild the current host

r-s                   # zsh alias for the above

sudo nixos-rebuild switch --flake .#v3   # raw equivalent
```

Build/deploy the ARM host (from `v3`, via aarch64 emulation):

```sh
nixos-rebuild switch --flake .#rock5b --target-host vinnie@rock5b
```

Format Nix files:

```sh
nix fmt               # nixfmt
```

Garbage collection runs automatically (`--keep-since 7d --keep 5`) through `nh clean`.

## Flake Inputs

| Input                | Description                                       |
|----------------------|---------------------------------------------------|
| `nixpkgs`            | `nixos-unstable` channel                          |
| `home-manager`       | Declarative user environment management           |
| `nix-index-database` | Prebuilt `nix-index` database + `comma`           |
| `niri`               | Wayland scrollable-tiling compositor              |
| `noctalia`           | Shell/panel components for Niri                   |
| `nixvim-config`      | Personal Neovim configuration flake               |
| `zen-browser`        | Zen browser package                               |
| `expert-ls`          | Elixir language server tooling                    |
| `ucodenix`           | AMD CPU microcode updates                         |
| `sops-nix`           | Secrets management with age encryption            |
| `nix-secrets`        | Private secrets repository (`git+ssh`, non-flake) |

## Notable Choices

- **Wayland-first.** Session variables force Wayland for Qt, Electron, and Firefox;
  XWayland (via `xwayland-satellite`) is available as a fallback.
- **`nh` over raw `nixos-rebuild`.** Colorized diffs and automatic generation cleanup.
- **Modern CLI replacements.** Standard tools are aliased: `cat`→bat, `find`→fd,
  `grep`→ripgrep, `tree`→eza, `df`→duf, plus Atuin history and zoxide jumping.
- **Rebase-only git.** Pulls rebase, with autosquash and rerere enabled.
- **TCP tuning.** BBR congestion control + CAKE qdisc, TCP Fast Open, and a set of
  TCP/ICMP hardening sysctls.
- **Firewall on.** Open ports limited to HTTP/HTTPS, Spotify Connect, and mDNS;
  `tailscale0` and `virbr0` are trusted interfaces.
- **Cross-arch from one flake.** A single `x86_64` machine builds and deploys the
  `aarch64` SBC through `binfmt` emulation.
