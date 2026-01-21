final: prev: {
  # Custom packages
  inherit (final.callPackage ../pkgs { })
    ccmenu
    deskpad
    faff
    oura
    ;

  # Firefox addons
  inherit (final.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
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

  git-town-status = final.writeBashBinChecked "git-town-status" ''
    # Placeholder for git-town-status
    echo "git-town-status"
  '';

  audio-switcher-d = prev.pog.pog {
    name = "audio-switcher-d";
    description = "Force audio switching";
    script = helpers: ''
      while true;
      do
       if [[ $(${prev.switchaudio-osx}/bin/SwitchAudioSource -t input -c) = "WH-1000XM5" ]]; then
         ${prev.switchaudio-osx}/bin/SwitchAudioSource -t input -s "Elgato Wave:3" || sleep 1;
       fi
      done
    '';
  };

  aipr = prev.pog.pog {
    name = "aipr";
    description = "Write a git commit message using ollama";
    script = helpers: builtins.readFile ../pkgs/scripts/aipr.sh;
  };
}
