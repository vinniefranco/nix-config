{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;

  services.blueman.enable = true;
}
