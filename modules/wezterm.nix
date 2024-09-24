{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs) fetchFromGithub;
  inherit (pkgs.stdenv) isDarwin;
in {
  home-manager.users."conlin.durbin" = {
    programs.wezterm = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
  };
}
