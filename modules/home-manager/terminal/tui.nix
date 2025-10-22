{
  pkgs,
  lib,
  ...
}:
let
in
{
  home.packages =
    with pkgs;
    lib.flatten [
      btop
      lazydocker
      atac
      discordo
      # calcure
    ];
}
