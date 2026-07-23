final: prev: {
  # botocore depends on ecdsa which nixpkgs marks insecure; override to allow it
  # without needing permittedInsecurePackages on every host.
  python3 = prev.python3.override {
    packageOverrides = pyFinal: pyPrev: {
      ecdsa = pyPrev.ecdsa.overrideAttrs (_: {
        meta = pyPrev.ecdsa.meta // {
          knownVulnerabilities = [ ];
        };
      });
    };
  };

  # onlykey-agent / libagent fixes for Python 3.14:
  #
  # The libagent-1.0.6 bundled by the onlykey-agent nixpkgs package is a local
  # derivation not accessible via python3.pkgs.libagent (which is 0.16.1). We must
  # override it in-place via the propagatedBuildInputs map.
  #
  # Two issues fixed on libagent:
  # 1. dontUsePythonCatchConflicts: onlykey-agent appends a second bech32-1.2.0
  #    (different store hash) to libagent's closure; the conflict check rejects it.
  # 2. pkg_resources removal: libagent/gpg/__init__.py does `import pkg_resources`
  #    to display version info. setuptools 82+ (Python 3.14) no longer ships
  #    pkg_resources as a top-level importable module. Patched to use
  #    importlib.metadata instead (stdlib since Python 3.8).
  onlykey-agent = prev.onlykey-agent.overrideAttrs (_: {
    dontUsePythonCatchConflicts = true;
    propagatedBuildInputs = map (
      dep:
      if dep.pname or "" == "libagent" then
        dep.overrideAttrs (old: {
          dontUsePythonCatchConflicts = true;
          patches = (old.patches or [ ]) ++ [ ./libagent-pkg-resources.patch ];
        })
      else
        dep
    ) (prev.onlykey-agent.propagatedBuildInputs or [ ]);
  });
  python3Packages = final.python3.pkgs;
  # Override direnv to avoid -linkmode=external on Darwin without CGo.
  # Remove once nixpkgs binary cache has the fix.
  direnv = prev.direnv.overrideAttrs (old: {
    buildPhase = ''
      go build -ldflags "-X main.bashPath=${prev.bash}/bin/bash" -o direnv
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp direnv $out/bin/
      make install-doc PREFIX=$out 2>/dev/null || true
    '';
  });

  # Custom packages
  inherit (final.callPackage ../pkgs { })
    ccmenu
    deskpad
    faff
    gh-worktree
    llm-tldr
    mozeidon
    mozeidon-native-app
    zerobrew
    zmx
    ;

  # Firefox addons
  inherit (final.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
  buildMozillaXpiAddon = final.buildFirefoxXpiAddon;
  firefox-addons = final.callPackage ../pkgs/firefox-addons { };

  # Utility functions and scripts
  writeBashBinChecked =
    name: text:
    prev.stdenv.mkDerivation {
      inherit name text;
      dontUnpack = true;
      passAsFile = "text";
      installPhase = ''
        mkdir -p $out/bin
        echo '#!/bin/bash' > $out/bin/${name}
        cat $textPath >> $out/bin/${name}
        chmod +x $out/bin/${name}
        ${prev.shellcheck}/bin/shellcheck $out/bin/${name}
      '';
    };

  # Custom scripts using pog
  nix-hash-unstable = prev.pog.pog {
    name = "nix-hash-unstable";
    description = "Hash nix-unstable and pin to file";
    arguments = [ ];
    script = helpers: ''
      ${prev.nix-prefetch-git}/bin/nix-prefetch-git --no-deepClone --branch-name nixpkgs-unstable \
      https://github.com/NixOS/nixpkgs.git | ${prev.jq}/bin/jq '{ rev: .rev, sha256: .sha256 }'
    '';
  };

  git-pull-status = final.writeBashBinChecked "git-pull-status" ''
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

  aipr = prev.pog.pog {
    name = "aipr";
    description = "Write a git commit message using ollama";
    script = helpers: builtins.readFile ../pkgs/scripts/aipr.sh;
  };
}
