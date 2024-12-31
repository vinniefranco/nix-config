{
  aalib,
  alsa-lib,
  appstream,
  appstream-glib,
  babl,
  bashInteractive,
  cairo,
  cfitsio,
  desktop-file-utils,
  fetchurl,
  findutils,
  gdk-pixbuf,
  gegl,
  gexiv2,
  ghostscript,
  gi-docgen,
  gjs,
  glib,
  glib-networking,
  gobject-introspection,
  gtk3,
  isocodes,
  lcms,
  lib,
  libarchive,
  libgudev,
  libheif,
  libiff,
  libilbm,
  libjxl,
  libmng,
  libmypaint,
  librsvg,
  libwebp,
  libwmf,
  libxslt,
  luajit,
  meson,
  mypaint-brushes1,
  ninja,
  openexr,
  perl538,
  pkg-config,
  poppler,
  poppler_data,
  python3,
  qoi,
  shared-mime-info,
  stdenv,
  vala,
  wrapGAppsHook,
  xorg,
  xvfb-run,
  fetchpatch,
}:
let
  python = python3.withPackages (pp: [ pp.pygobject3 ]);
  lua = luajit.withPackages (ps: [ ps.lgi ]);

  gegl-dev = gegl.overrideAttrs (oldAttrs: rec {
    version = "0.4.50";

    src = fetchurl {
      url = "https://download.gimp.org/pub/gegl/${lib.versions.majorMinor version}/gegl-${version}.tar.xz";
      hash = "sha256-YISWmwbuhspxFCEzdz8n4T8C5aaiLCz85FLsqt23kME=";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gimp";
  version = "3.0.0-RC1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "http://download.gimp.org/pub/gimp/v${lib.versions.majorMinor finalAttrs.version}/gimp-${finalAttrs.version}.tar.xz";
    hash = "sha256-s9CyZMXjjnifqvNBcAM5fzJAAUxZx/QX+co705xf+2Y=";
  };

  patches = [
    (fetchpatch {
      url = "https://git.sr.ht/~fd/nix-configs/blob/trunk/pkgs/gimp-devel/meson-gtls.patch";
      hash = "sha256-eTr2egwhBhnbB/3laQMfM6U/6Fgta01SkiH+UZPuadc=";
    })
    (fetchpatch {
      url = "https://git.sr.ht/~fd/nix-configs/blob/trunk/pkgs/gimp-devel/pygimp-interp.patch";
      hash = "sha256-8A/CnDNZC7XK3zwHf1jrDqQuhYoX/qufV3g0Ir2YJA4=";
    })
  ];

  nativeBuildInputs = [
    aalib
    alsa-lib
    appstream
    bashInteractive
    findutils
    ghostscript
    gi-docgen
    isocodes
    libarchive
    libheif
    libiff
    libilbm
    libjxl
    libmng
    libwebp
    libxslt
    meson
    ninja
    perl538
    pkg-config
    vala
    wrapGAppsHook
    xvfb-run
  ];

  buildInputs = [
    aalib
    appstream-glib
    babl
    cairo
    cfitsio
    desktop-file-utils
    gdk-pixbuf
    gegl-dev
    gexiv2
    ghostscript
    gjs
    glib
    glib-networking
    gobject-introspection
    gtk3
    lcms
    libgudev
    libheif
    libjxl
    libmng
    libmypaint
    librsvg
    libwebp
    libwmf
    lua
    mypaint-brushes1
    openexr
    poppler
    poppler_data
    python
    qoi
    shared-mime-info
    xorg.libXmu
    xorg.libXpm
  ];

  # We do not compile the splash image because the build is broken for some reason
  preConfigure = ''
    patchShebangs tools/gimp-mkenums app/tests/create_test_env.sh plug-ins/script-fu/scripts/ts-helloworld.scm plug-ins/python/python-eval.py tools/in-build-gimp.sh
    sed -i "/subdir('gimp-data\/images\/')/d" meson.build
  '';

  mesonFlags = [
    "-Dheadless-tests=disabled"
    "-Dlua=true"
  ];

  enableParallelBuilding = true;

  doCheck = false;

  meta = {
    description = "The GNU Image Manipulation Program: Development Edition";
    homepage = "https://www.gimp.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gimp";
  };
})
