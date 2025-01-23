{
  description = "wuz's stash of fresh packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    pog.url = "github:jpetrucciani/pog";

    rust-nightly = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      rust-nightly,
      pog,
      ...
    }:
    {
      overlay = final: prev: {
        inherit (self.packages.${final.system})
          writeBashBinChecked
          nix-hash-unstable
          git-pull-status
          git-town-status
          audio-switcher-d
          ccmenu
          deskpad
          hm-zen-browser
          ;
        inherit (final.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
        firefox-addons = final.callPackage ./packages/firefox-addons { };
      };
      darwinModules.hm-zen-browser = import ./home-manager/hm-zen-browser;
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
              overlays = [
                rust-nightly.overlays.default
                pog.overlays.${system}.default
              ];
              config = {
                allowUnfree = true;
                allowBroken = true;
                allowUnsupportedSystem = true;
              };
            };
          in
          {
            packages =
              flake-utils.lib.flattenTree (
                import ./packages {
                  inherit
                    pkgs
                    ;
                }
              )
              // rec {
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

                nix-hash-unstable = pkgs.pog.pog {
                  name = "nix-hash-unstable";
                  description = "Hash nix-unstable and pin to file";
                  arguments = [ { name = "FILE"; } ];
                  script = helpers: ''
                    path="$1"
                    out=$(${pkgs.nix-prefetch-git}/bin/nix-prefetch-git \
                      --quiet \
                      --no-deepClone \
                      --branch-name nixpkgs-unstable \
                      https://github.com/NixOS/nixpkgs.git | \
                    ${pkgs.jq}/bin/jq '{ rev: .rev, sha256: .sha256 }')
                    echo "$path"
                    echo "$out"
                    # if [ -n "$path" ]; then
                    #   echo "$out" > "$path"
                    # else
                    #   echo "$out"
                    # fi
                  '';
                };

                audio-switcher-d = pkgs.pog.pog {
                  name = "audio-switcher-d";
                  description = "Force audio switching";
                  script = helpers: ''
                    while true;
                    do
                     if [[ $(${pkgs.switchaudio-osx}/bin/SwitchAudioSource -t input -c) = "WH-1000XM5" ]]; then
                       ${pkgs.switchaudio-osx}/bin/SwitchAudioSource -t input -s "Elgato Wave:3" || sleep 1;
                     fi
                    done
                  '';
                };

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
