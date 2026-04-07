{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets;
in
{
  imports = [
    ./desktop
    ./dev
    ./media
    ./terminal
    inputs.sops-nix.homeManagerModules.sops
    inputs.noctalia.homeModules.default
    inputs.niri.homeModules.niri
  ];

  home.username = "vinnie";
  home.homeDirectory = "/home/vinnie";

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    age.keyFile = "/home/vinnie/.config/sops/age/keys.txt";
    secrets.openrouter_api = {
      path = "%r/openrouter_api.key";
    };
  };

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    gimp
    krita
    libreoffice
    obsidian
    postman
  ];

  home.sessionVariables = {
    CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
