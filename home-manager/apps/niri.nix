{ pkgs, ... }:
let
  v3_image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/ly/wallhaven-ly95v2.jpg";
    sha256 = "07ndns085zkxdclfjz1if0var95pvisvl7b6hsqhfx496vadmpnw";
  };
in
{
  home.file.".config/niri/config.kdl".source = pkgs.replaceVars ./config/niri.kdl {
    v3_image = "${v3_image}";
    DEFAULT_AUDIO_SINK = null;
    DEFAULT_AUDIO_SOURCE = null;
  };
}
