{ pkgs, inputs, ... }:

{
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    inputs.nixvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
    age
    claude-code
    gcc
    gource
    pgcli
    sops
  ];
}
