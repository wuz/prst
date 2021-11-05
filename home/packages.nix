{ config, lib, ... }:
let
  pkgs = import ../default.nix { };
  inherit (pkgs.hax) isDarwin fetchFromGitHub;
  kwbauson-cfg = import (fetchFromGitHub {
    owner = "kwbauson";
    repo = "cfg";
    rev = "main";
    sha256 = "0l4fhngqlcgfj5xz001hak1wlc98l7rrzwrxfdqs72kr1pl1myi7";
  });
  # lua-language-server = pkgs.callPackage ../packages/lua-language-server.nix { pkgs = pkgs; };
  pkgsX86 = import <nixpkgs> { localSystem = "x86_64-darwin"; };
  python-with-global-packages = pkgsX86.python3.withPackages
    (ps: with ps; [ pip botocore setuptools pynvim ]);
in with pkgs.hax; {
  home.packages = with pkgs;
    lib.flatten [
      (lib.optional isDarwin [ reattach-to-user-namespace ])
      bandwhich
      bottom
      cargo
      coreutils-full
      curl
      diffutils
      du-dust
      exa
      fd
      figlet
      findutils
      fontforge
      fontforge-fonttools
      fzf
      gawk
      gcc
      gnugrep
      gnupg
      gnused
      go
      grex
      hadolint
      heroku
      hyperfine
      ipfs
      jq
      libiconv
      lolcat
      pkgsX86.libuv
      pkgsX86.luajit
      mas
      moreutils
      msgpack
      neovim-unwrapped
      tree-sitter
      ninja
      nix-prefetch-git
      nix-hash-unstable
      pkgsX86.nixfmt
      nnn
      nodejs
      openssh
      pkg-config
      pinentry_mac
      procs
      pssh
      pup
      pkgsX86.python2
      python-with-global-packages
      ranger
      rename
      ripgrep
      rsync
      ruby
      rubocop
      rustc
      rustfmt
      pkgsX86.shellcheck
      solargraph
      ssh-copy-id
      tealdeer
      # thefuck
      time
      tokei
      tree
      unzip
      wget
      yarn
      zsh-you-should-use
    ];
}
