{ ... }:
{
  conlin.lua = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          lua
          luarocks
          luajitPackages.luarocks
          selene
          stylua
          luaformatter
        ];
      };
  };
}
