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
  oura = callPackage ./oura.nix { };
}
