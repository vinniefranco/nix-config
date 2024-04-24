{ config, lib, pkgs, ... }:

let cfg = config.services.thermald;
in {
  imports = [ ];

  options = { };

  config = {
    services.thermald.enable = true;
    services.thermald.debug = true;
    services.thermald.configFile = ./thermald/thermal-conf.xml;
  };
}
