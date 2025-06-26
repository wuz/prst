{
  inputs,
  pkgs,
  lib,
  user,
  ...
}:
let
in
{
  options.helix = lib.mkEnableOption "helix";
  config = {
    programs.helix = {
      enable = true;
    };
  };
}
