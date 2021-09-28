{ config, lib, ... }:
let
  pkgs = import ../default.nix { };
  inherit (pkgs.hax) isDarwin fetchFromGitHub;
  kwbauson-cfg = import (fetchFromGitHub {
    owner = "kwbauson";
    repo = "cfg";
    rev = "main";
    sha256 = "1hcvgyz4jdd55bq300iskn4ijl9qnfy9aqnnr0llpjmczf343jr0";
  });
  # lua-language-server = pkgs.callPackage ../packages/lua-language-server.nix { pkgs = pkgs; };
  pkgsX86 = import <nixpkgs> { localSystem = "x86_64-darwin"; };
  python-with-global-packages = pkgsX86.python3.withPackages
    (ps: with ps; [ pip botocore setuptools pynvim ]);
in with pkgs.hax; {
  home.packages = with pkgs;
    lib.flatten [
      (lib.optional isDarwin [ reattach-to-user-namespace ])
      # lua-language-server
      bandwhich
      bottom
      # pkgsX86.cachix
      cargo
      coreutils-full
      # clangStdenv
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
      gcc11
      gnugrep
      gnupg
      gnused
      go
      grex
      heroku
      hyperfine
      ipfs
      jq
      kwbauson-cfg.better-comma
      libiconvReal
      lolcat
      pkgsX86.libuv
      pkgsX86.luajit
      mas
      moreutils
      msgpack
      pkgsX86.neovim-unwrapped
      pkgsX86.tree-sitter
      ninja
      # nix-bash-completions
      nix-prefetch-git
      nix-hash-unstable
      pkgsX86.nixfmt
      nnn
      nodejs
      nushell
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
