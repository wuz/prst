{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs) fetchFromGithub;
  inherit (pkgs.stdenv) isDarwin;
  personalEmail = "c@wuz.sh";
  workEmail = "conlin@figurehr.com";
  username = "wuz";
in {
  home-manager.users.wuz = {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.mcfly={
      enable = true;
      enableZshIntegration = true;
      keyScheme = "vim";
    };
    programs.zoxide.enable = true;
    # programs.starship = {
    #   enable = true;
    # };
    programs.gpg = {
      enable = true;
    };
    programs.bat = {
      enable = true;
      config = {
        theme = "DankNeon";
        italic-text = "always";
        style = "numbers,changes";
      };
      themes = {
        DankNeon = builtins.readFile (pkgs.fetchFromGitHub {
          owner = "DankNeon";
          repo = "sublime"; # Bat uses sublime syntax for its themes
          rev = "31dd0216c33225cde3968f882dca0ad1375bc4e3";
          sha256 = "1xla6qln6fj123q92si59va90syn3fjkn4ynps42fvawyx1n4rld";
        } + "/Dank_Neon.tmTheme");
      };
    };
  };
}
