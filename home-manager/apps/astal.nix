{ inputs, ... }:

{
  home.packages = [ inputs.astal-bar.packages.x86_64-linux.default ];
}
