{ ... }:
{
  conlin.tui = {
    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages =
          with pkgs;
          lib.flatten [
            btop
            lazydocker
            atac
            discordo
          ];
      };
  };
}
