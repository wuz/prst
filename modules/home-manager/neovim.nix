{ pkgs, lib, ... }:
let aliases = { vim = "nvim"; };
in {
  options.neovim = lib.mkEnableOption "neovim";
  config = {
    home.shellAliases = aliases;
    programs.neovim = {
      package = pkgs.neovim;
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}

