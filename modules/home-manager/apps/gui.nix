{
  pkgs,
  lib,
  ...
}:
let
in
{
  home.packages = with pkgs; [
    # davmail
    spotify
    raycast
    keybase
    discord
    vscode
  ];
}
