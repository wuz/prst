{ lib, ... }:
{
  options.zellij = lib.mkEnableOption "zellij";
  config = {
    programs.zellij = {
      enable = false;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
    xdg.configFile = {
      "zellij/config.kdl".text = builtins.readFile ../../../configs/zellij.kdl;
    };
  };
}
