{ pkgs, inputs, ... }:
{
  programs.ghostty = {
    enable = true;
    shellIntegration = {
      enable = true;
    };
    package = null;
  };
  xdg.configFile."ghostty" = {
    recursive = true;
    source = ../../../configs/ghostty;
  };
}
