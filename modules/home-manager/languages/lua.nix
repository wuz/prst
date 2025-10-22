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
      luarocks
      luajitPackages.luarocks
      selene
      stylua
      luaformatter
    ];
}
