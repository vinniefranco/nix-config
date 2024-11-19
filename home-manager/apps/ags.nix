{ inputs, ... }:

{
  home.packages = [ inputs.ags-bar.packages.x86_64-linux.default ];
}
