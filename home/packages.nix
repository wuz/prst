{ config, pkgs, lib, ... }:

let
  inherit (pkgs.hax) isDarwin fetchFromGitHub;
  kwbauson-cfg = import (fetchFromGitHub {
    owner = "kwbauson";
    repo = "cfg";
    rev = "1cd4b9097516358844f1d75551ad514dcf435011";
    sha256 = "0vp1fwqwkn3x5sr57gcrc3ippjyx6c7a8whfp0dqax7wfmd5nznv";
  });
in with pkgs.hax; {
  home.packages = with pkgs;
    lib.flatten [
      (lib.optional isDarwin [
        (import (fetchTarball {
          url =
            "https://github.com/NixOS/nixpkgs/archive/266b6cdea3203ae0164c9974cfb4d58c6ff3b3fe.tar.gz";
          sha256 = "1c8fymvb5r8xhp55ckynzyrk731p9bnmfs0k4yxz0ykxz5hpf4p4";
        }) { }).wezterm
      ])
      act
      bandwhich
      bash_5
      bash-completion
      bashInteractive
      bat
      bottom
      coreutils-full
      pinentry_mac
      mas
      curl
      delta
      diffutils
      dust
      exa
      fd
      figlet
      ruby
      nodejs
      yarn
      fzf
      gawk
      gh
      gitAndTools.delta
      gitAndTools.gh
      gnugrep
      gnupg
      gnused
      time
      grex
      hyperfine
      # keybase
      kwbauson-cfg.better-comma
      kwbauson-cfg.git-trim
      kwbauson-cfg.nle
      luajit
      mcfly
      moreutils
      msgpack
      neovim-unwrapped
      ninja
      findutils
      nix-bash-completions
      nixfmt
      nnn
      nushell
      openssh
      ssh-copy-id
      jq
      go
      procs
      pssh
      pup
      ranger
      rename
      ripgrep
      rsync
      cargo
      rustc
      rustfmt
      shellcheck
      thefuck
      tealdeer
      tmux
      tokei
      tree
      tree-sitter
      unzip
      waterfox
      wget
      zoxide
    ];
}
