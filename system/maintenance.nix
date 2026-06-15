{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  # Firmware updates (BIOS, SSD, Thunderbolt dock, etc.) via `fwupdmgr`.
  services.fwupd.enable = true;

  # Power profile switching (power-saver / balanced / performance) for the
  # laptop; integrates with the Noctalia bar.
  services.power-profiles-daemon.enable = true;

  # Compressed RAM swap. Sits at a higher priority than the on-disk swap and
  # keeps the machine responsive under memory pressure (VMs + Docker + Electron).
  zramSwap.enable = true;

  # Catch silent bit-rot on the Btrfs filesystems.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [
      "/"
      "/home"
      "/nix"
    ];
  };
}
