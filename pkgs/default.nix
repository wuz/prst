{
  pkgs ? import <nixpkgs> { },
}:
let
  inherit (pkgs) callPackage;
in
{
  ccmenu = callPackage ./ccmenu.nix { };
  deskpad = callPackage ./deskpad.nix { };
  faff = callPackage ./faff.nix { };
  gh-worktree = callPackage ./gh-worktree.nix { };
  llm-tldr = callPackage ./llm-tldr.nix { };
  mozeidon = callPackage ./mozeidon.nix { };
  mozeidon-native-app = callPackage ./mozeidon-native-app.nix { };
  zerobrew = callPackage ./zerobrew.nix { };
  zmx = callPackage ./zmx.nix { };
}
