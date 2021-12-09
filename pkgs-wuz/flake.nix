{
  description = "wuz's stash of fresh packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    neovide-src = {
      url = "github:neovide/neovide";
      flake = false;
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-nightly = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = args@{ self, flake-utils, nixpkgs, rust-nightly, ... }:
    {
      overlay = final: prev: {
        inherit (self.packages.${final.system}) neovide-git writeBashBinChecked;
      };
    } // flake-utils.lib.eachSystem [
      "aarch64-darwin"
      "x86_64-linux"
      "aarch64-linux"
    ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-nightly.overlay ];
          allowBroken = true;
          allowUnsupportedSystem = true;
        };
        version = "999-unstable";
      in {
        packages = rec {
          neovide-git = (pkgs.neovide.overrideAttrs (old: {
            inherit version;
            src = args.neovide-src;
            buildInputs = (old.buildInputs or [ ])
              ++ (with pkgs; [ rust-bin.nightly.latest.default ]);
          }));
          writeBashBinChecked = name: text:
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
        };
      });
}
