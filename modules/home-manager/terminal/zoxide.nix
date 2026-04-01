{ lib, config, ... }:
{
  options.zoxide.enable = lib.mkEnableOption "zoxide";
  config = lib.mkIf config.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
  };
}
