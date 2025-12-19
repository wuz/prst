{
  inputs,
  pkgs,
  lib,
  user,
  ...
}:
let
  aliases = {
    vim = "nvim";
  };
in
{
  options.neovim = lib.mkEnableOption "neovim";
  config = {
    home.shellAliases = aliases;
    programs.neovim = {
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
