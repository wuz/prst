{ lib, config, ... }:
{
  options.direnv.enable = lib.mkEnableOption "direnv";
  config = lib.mkIf config.direnv.enable {
    programs.direnv-instant.enable = true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
  };
}
