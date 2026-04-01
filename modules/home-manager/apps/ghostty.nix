{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs.ghostty = {
    enable = false;
    enableZshIntegration = true;
    # package = null;
  };
  xdg.configFile."ghostty" = {
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink ../../../configs/ghostty;
  };
}
