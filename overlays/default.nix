{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    vivaldi = prev.vivaldi.override {
      commandLineArgs = "--ozone-platform=wayland";
    };

    claude-code = prev.claude-code.overrideAttrs (old: rec {
      version = "2.1.170";
      src = prev.fetchurl {
        url = "https://downloads.claude.ai/claude-code-releases/${version}/${
          final.stdenv.hostPlatform.node.platform
        }-${final.stdenv.hostPlatform.node.arch}/claude";
        sha256 =
          {
            "x86_64-linux" = "849e007277a0442ab27570d3e3d6d43787507946590e8dd1947e5a39b7081f9e";
            "aarch64-linux" = "1bb9d032440a75532f7dd4cafbc687f220aaf16c63eba17e192dfbec2f04bd25";
          }
          .${final.stdenv.hostPlatform.system};
      };
    });
  };
}
