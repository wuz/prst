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
      nix-tree
      nix-prefetch-git
      nix-hash-unstable
      comma
      nixd
      cachix
      nixfmt-rfc-style
    ];
}
