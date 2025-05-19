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
      lua
      luajitPackages.luarocks
      selene
      stylua
      luaformatter
    ];
}
