{ ... }:
{
  prst.nixtools = {
    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages =
          with pkgs;
          lib.flatten [
            nix-tree
            nix-prefetch-git
            comma
            nixd
            nixfmt-rfc-style
            statix
            deadnix
          ];
      };
  };
}
