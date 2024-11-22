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
      rustc
      rustfmt
      cargo
    ];
}
