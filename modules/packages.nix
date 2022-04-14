{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  # inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (pkgs) fetchFromGitHub writeBashBinChecked;
  kwbauson-cfg = import (fetchFromGitHub {
    owner = "kwbauson";
    repo = "cfg";
    rev = "main";
    sha256 = "sha256-E4L7s/B6C0EQpxwHeUEsHCFIlSFT4rmk9r4Q1L5hUms=";
  });
  pkgsX86 = import <nixpkgs> { localSystem = "x86_64-darwin"; };

  statix = import (fetchFromGitHub {
    owner = "nerdypepper";
    repo = "statix";
    rev = "4e063b2abc402ac4d6902647e821978269025c7d";
    sha256 = "0k5zgf1vssjzikbkknl0czv43kai48nvr1krhjs65w2gfwygqikf";
  });
  python-with-global-packages =
    pkgs.python3.withPackages (ps: with ps; [ pip botocore setuptools pynvim ]);
  nix-hash-unstable = (writeBashBinChecked "nix-hash-unstable" ''
    ${pkgs.nix-prefetch-git}/bin/nix-prefetch-git \
    --quiet \
    --no-deepClone \
    --branch-name nixpkgs-unstable \
    https://github.com/NixOS/nixpkgs.git | \
    ${pkgs.jq}/bin/jq '{ rev: .rev, sha256: .sha256 }'
  '');
in {
  home-manager.users.wuz = {
    home.packages = with pkgs;
      lib.flatten [
        (lib.optional stdenv.isDarwin [ reattach-to-user-namespace ])

        libuv

        nix-prefetch-git
        nix-hash-unstable
        statix.defaultPackage.aarch64-darwin
        nixfmt

        fontforge
        fontforge-fonttools
        google-fonts

        gcc
        msgpack
        libiconv
        coreutils-full
        findutils
        diffutils
        moreutils
        curl
        gnugrep
        gnupg
        gnused
        gawk

        shellcheck
        shellharden
        shfmt
        nodejs
        yarn
        rustc
        rustfmt
        cargo
        go
        ruby_3_0
        rubocop
        python-with-global-packages
        python2

        exa
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

        neovim-nightly
        tree-sitter
        
        bitwarden-cli

        selene
        stylua
        luaformatter
        solargraph
        nodePackages.fixjson

        kwbauson-cfg.better-comma

        openssh
        openssl
        pinentry_mac


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
      ];
  };
}
