{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs)
    fetchFromGitHub writeBashBinChecked nix-hash-unstable git-pull-status;

  # pkgsX86 = import <nixpkgs> { localSystem = "x86_64-darwin"; };

  statix = import (fetchFromGitHub {
    owner = "nerdypepper";
    repo = "statix";
    rev = "4e063b2abc402ac4d6902647e821978269025c7d";
    sha256 = "0k5zgf1vssjzikbkknl0czv43kai48nvr1krhjs65w2gfwygqikf";
  });

  python-with-global-packages = pkgs.python3.withPackages
    (ps: with ps; [ pip botocore setuptools pynvim fonttools brotli zopfli ]);

  optList = conditional: list: if conditional then list else [ ];
in {
  home-manager.users."wuz" = {
    home.packages = with pkgs;
      lib.flatten [
        (optList stdenv.isDarwin [ reattach-to-user-namespace ])

        nix-prefetch-git
        # statix.defaultPackage.aarch64-darwin

        fontforge
        fontforge-fonttools
        google-fonts

        python-with-global-packages

        eza
        jq
        bottom
        hyperfine
        du-dust
        procs
        fd
        figlet
        pup
        ranger
        time
        tokei
        tree
        unzip
        wget
        rename
        bandwhich
        grex
        ripgrep
        rsync
        tealdeer
        heroku

        w3m

        tree-sitter

        selene
        stylua
        luaformatter
        solargraph
        nodePackages.fixjson
        corepack_21
        vscode

        openssh
        openssl
        libsecret
        dbus

        # GUI programs
        # davmail

        /* fzf
           hadolint
           ipfs
           lolcat
           pkgsX86.luajit
           ninja
           nnn
           pkg-config
           pssh
           ssh-copy-id
           # thefuck
        */

        # bash scripts
        nix-hash-unstable
        git-pull-status
      ];
  };
}
