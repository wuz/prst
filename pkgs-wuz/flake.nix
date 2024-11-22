{
  description = "wuz's stash of fresh packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    rust-nightly = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    args@{
      self,
      flake-utils,
      nixpkgs,
      rust-nightly,
      ...
    }:
    {
      overlay = final: prev: {
        inherit (self.packages.${final.system})
          writeBashBinChecked
          nix-hash-unstable
          git-pull-status
          git-town-status
          ccmenu
          # homebrew
          ;
      };
    }
    //
      flake-utils.lib.eachSystem
        [
          "aarch64-darwin"
          "x86_64-linux"
          "aarch64-linux"
        ]
        (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ rust-nightly.overlays.default ];
              config = {
                allowUnfree = true;
                allowBroken = true;
                allowUnsupportedSystem = true;
              };
            };
          in
          {
            packages = rec {

              ccmenu = pkgs.callPackage ./packages/ccmenu.nix { inherit pkgs; };

              # homebrew = pkgs.callPackage ./tools/homebrew.nix {
              #   inherit pkgs;
              # };

              writeBashBinChecked =
                name: text:
                pkgs.stdenv.mkDerivation {
                  inherit name text;
                  dontUnpack = true;
                  passAsFile = "text";
                  installPhase = ''
                    mkdir -p $out/bin
                    echo '#!/bin/bash' > $out/bin/${name}
                    cat $textPath >> $out/bin/${name}
                    chmod +x $out/bin/${name}
                    ${pkgs.shellcheck}/bin/shellcheck $out/bin/${name}
                  '';
                };

              nix-hash-unstable = writeBashBinChecked "nix-hash-unstable" ''
                ${pkgs.nix-prefetch-git}/bin/nix-prefetch-git \
                --quiet \
                --no-deepClone \
                --branch-name nixpkgs-unstable \
                https://github.com/NixOS/nixpkgs.git | \
                ${pkgs.jq}/bin/jq '{ rev: .rev, sha256: .sha256 }'
              '';

              git-pull-status = writeBashBinChecked "git-pull-status" ''
                UPSTREAM=$1
                LOCAL=$(git rev-parse @)
                REMOTE=$(git rev-parse "$UPSTREAM")
                BASE=$(git merge-base @ "$UPSTREAM")

                if [ "$LOCAL" = "$REMOTE" ]; then
                    echo "Up-to-date"
                elif [ "$LOCAL" = "$BASE" ]; then
                    echo "Need to pull"
                elif [ "$REMOTE" = "$BASE" ]; then
                    echo "Need to push"
                else
                    echo "Diverged"
                fi
              '';
            };
          }
        );
}
