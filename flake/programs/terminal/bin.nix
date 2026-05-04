{ ... }:
{
  conlin.bin = {
    homeManager =
      { pkgs, lib, ... }:
      {
        home.packages =
          with pkgs;
          lib.flatten [
            (lib.optional stdenv.isDarwin darwin.trash)
            eza
            jq
            bottom
            hyperfine
            dust
            procs
            fd
            figlet
            sd
            pup
            ranger
            tokei
            tree
            unzip
            wget
            rename
            bandwhich
            grex
            ripgrep
            rsync
            melt
            broot
            cloak
            vegeta
            gowall
            devenv
          ];
      };
  };
}
