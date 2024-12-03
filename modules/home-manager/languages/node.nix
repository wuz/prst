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
      nodejs_22
      corepack_22
    ];
}
