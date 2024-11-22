{ pkgs, inputs, ... }:
{
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };
  xdg.configFile."wezterm" = {
    recursive = true;
    source = ../../../configs/wezterm;
  };
}
