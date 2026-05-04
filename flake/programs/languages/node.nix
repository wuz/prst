{ ... }:
{
  conlin.node = {
    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages =
          with pkgs;
          lib.flatten [
            nodejs_22
            bun
            corepack_22
          ];
      };
  };
}
