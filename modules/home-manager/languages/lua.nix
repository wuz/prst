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
      selene
      stylua
      luaformatter
      lua
      luajitPackages.luarocks
    ];
}
