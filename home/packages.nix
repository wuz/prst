{ config, pkgs, lib, ... }:

let
  inherit (pkgs.hax) isDarwin fetchFromGitHub;
  kwbauson-cfg = import (fetchFromGitHub {
    owner = "kwbauson";
    repo = "cfg";
    rev = "1cd4b9097516358844f1d75551ad514dcf435011";
    sha256 = "0vp1fwqwkn3x5sr57gcrc3ippjyx6c7a8whfp0dqax7wfmd5nznv";
  });
  # lua-language-server = pkgs.callPackage ../packages/lua-language-server.nix { pkgs = pkgs; };
in with pkgs.hax; {
  home.packages = with pkgs;
    lib.flatten [
      (lib.optional isDarwin [
        reattach-to-user-namespace
        (writeBashBinChecked "devenv" ''
          #!/usr/bin/osascript
          tell application "iTerm2"
              tell current session of current tab of current window
                  split horizontally with default profile
                  split vertically with default profile
              end tell
              tell third session of current tab of current window
                  split vertically with default profile
              end tell
          end tell
        '')
      ])
      # lua-language-server
      act
      bandwhich
      bash-completion
      bashInteractive
      bash_5
      bat
      bottom
      cachix
      cargo
      coreutils-full
      clangStdenv
      curl
      delta
      diffutils
      dust
      exa
      fd
      figlet
      findutils
      fontforge
      fontforge-fonttools
      fzf
      gawk
      gcc11
      gh
      gitAndTools.delta
      gitAndTools.gh
      gnugrep
      gnupg
      gnused
      go
      grex
      hyperfine
      jq
      kwbauson-cfg.better-comma
      kwbauson-cfg.git-trim
      kwbauson-cfg.nle
      libiconvReal
      luajit
      mas
      mcfly
      moreutils
      msgpack
      neovim-unwrapped
      ninja
      nix-bash-completions
      nixfmt
      nnn
      nodejs
      nushell
      openssh
      pkg-config
      pinentry_mac
      procs
      pssh
      pup
      python2
      python3
      ranger
      rename
      ripgrep
      rsync
      ruby
      rufo
      rubocop
      rustc
      rustfmt
      shellcheck
      solargraph
      ssh-copy-id
      tealdeer
      thefuck
      time
      tmux
      tokei
      tree
      tree-sitter
      unzip
      wget
      yarn
      zoxide

    ];
}
