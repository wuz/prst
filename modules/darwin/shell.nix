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
  programs.bash.enable = true;
  programs.zsh.enable = true;
}
