{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  virtualisation.docker = {
    enable = config.networking.hostName == "v3";
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
