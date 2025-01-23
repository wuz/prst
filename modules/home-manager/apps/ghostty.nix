{ pkgs, inputs, ... }:
{
  programs.ghostty = {
    enable = false;
    enableZshIntegration = true;
    # package = null;
  };
  xdg.configFile."ghostty" = {
    recursive = true;
    source = ../../../configs/ghostty;
  };
}
