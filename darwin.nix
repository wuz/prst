{ config, pkgs, ... }:

{
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";

  # environment.systemPackages =
  #   [ pkgs.vim
  #   ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  imports = [ <home-manager/nix-darwin> ];
  system.stateVersion = 4;
}
