{ pkgs }:
let
  imgLink = "https://wallpaperaccess.com/full/84247.jpg";
  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-O4LTuDNv4cjwbcBspnoU8Lt5ggWc/0SVsnMZTycWFY0=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-sugar-dark-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50176c3b34df29003726ef9708813d06271";
    sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm assets/background.jpg
    cp -r ${image} $out/assets/background.jpg
  '';
}
