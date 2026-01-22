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
  oura = callPackage ./oura.nix { };
  wt = callPackage ./wt.nix { };
}
