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
      # discordo
      btop
      lazydocker
      atac
    ];
}
