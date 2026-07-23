{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";

    programs = {
      keep-sorted.enable = true;

      nixf-diagnose = {
        enable = true;
        priority = -1; # run before nixfmt
      };

      nixfmt = {
        enable = true;
        strict = true;
      };

      just.enable = true;
      prettier = {
        enable = true;
        includes = [ "*.md" ];
      };
      shellcheck.enable = true;
      shfmt.enable = true;
      stylua.enable = true;
      taplo.enable = true;
      yamlfmt.enable = true;
    };

    settings.global.excludes = [
      "*.age"
      "flake.lock"
      "configs/*"
      # sops-encrypted files — reformatting risks corrupting them
      "secrets/*"
    ];
  };
}
