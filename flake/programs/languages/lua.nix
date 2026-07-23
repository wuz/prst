{ ... }: {
  work.lua = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        lua
        luarocks
        selene
        stylua
        luaformatter
      ];
    };
  };
}
