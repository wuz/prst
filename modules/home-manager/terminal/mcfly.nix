{ lib, config, ... }:
{
  options.mcfly.enable = lib.mkEnableOption "mcfly";
  config = lib.mkIf config.mcfly.enable {
    programs.mcfly = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
      keyScheme = "vim";
    };
  };
}
