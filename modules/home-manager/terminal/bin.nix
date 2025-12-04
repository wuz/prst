{
  pkgs,
  lib,
  ...
}:
let
in
{
  home.packages =
    with pkgs;
    lib.flatten [
      darwin.trash
      eza
      jq
      bottom
      hyperfine
      dust
      procs
      fd
      figlet
      sd
      pup
      ranger
      # time
      tokei
      tree
      unzip
      wget
      rename
      bandwhich
      grex
      ripgrep
      rsync
      # tealdeer
      melt
      broot
      cloak
      vegeta
      gowall
      devenv
    ];
}
