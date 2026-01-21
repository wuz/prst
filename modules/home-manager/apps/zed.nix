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
  options.zed-editor = lib.mkEnableOption "zed-editor";
  config = {
    programs.zed-editor = {
      enable = true;
    };
  };
}
