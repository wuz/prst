{ ... }: {
  work.node = {
    homeManager = { pkgs, lib, ... }: {
      home.packages =
        with pkgs;
        lib.flatten [
          nodejs_26
          bun
          corepack
        ];
    };
  };
}
