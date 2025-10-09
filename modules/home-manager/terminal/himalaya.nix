{
  config,
  lib,
  ...
}:
let
in
{
  options.himalaya.enable = lib.mkEnableOption "himalaya";
  config = lib.mkIf config.himalaya.enable {
    programs.himalaya = {
      enable = true;
      settings = {
        downloads-dir = "${config.home.homeDirectory}/Downloads";
      };
    };
  };
}
