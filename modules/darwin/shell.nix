{ pkgs, ... }:
let
  shells = with pkgs; [
    bashInteractive
    zsh
  ];
in
{
  environment.shells = shells;
  environment.systemPackages = shells;
  programs.zsh.enable = true;
}
