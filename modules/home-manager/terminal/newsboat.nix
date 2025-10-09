{ lib, ... }:
{
  options.newsboat = lib.mkEnableOption "newsboat";
  config = {
    programs.newsboat = {
      enable = true;
    };
  };
}
