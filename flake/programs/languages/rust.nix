{ ... }:
{
  work.rust = {
    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages =
          with pkgs;
          lib.flatten [
            rustc
            rustfmt
            cargo
            rust-analyzer
          ];
      };
  };
}
