{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  security.polkit.enable = true;

  security = {
    pam = {
      services = { };
      loginLimits = [
        {
          domain = "@users";
          item = "rtprio";
          type = "-";
          value = 1;
        }
        {
          domain = "*";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];
    };
  };
}
