{
  pkgs,
  lib,
  user,
  ...
}:
let
  calendar_file = "/Users/${user.username}/Library/Mobile Documents/com~apple~CloudDocs";
  aliases = {
    vim = "nvim";
    cal = "nvim ${calendar_file}";
  };
in
{
  options.neovim = lib.mkEnableOption "neovim";
  config = {
    home.shellAliases = aliases;
    programs.neovim = {
      # package = pkgs.neovim;
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
