{ pkgs, lib, ... }:
{
  options.bat = lib.mkEnableOption "bat";
  config = {
    home.shellAliases = {
      cat = "bat";
    };
    programs.bat = {
      enable = true;
      config = {
        theme = "DankNeon";
        italic-text = "always";
        style = "numbers,changes";
      };
      themes = {
        DankNeon = {
          src = pkgs.fetchFromGitHub {
            owner = "DankNeon";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "31dd0216c33225cde3968f882dca0ad1375bc4e3";
            sha256 = "1xla6qln6fj123q92si59va90syn3fjkn4ynps42fvawyx1n4rld";
          };
          file = "Dank_Neon.tmTheme";
        };
      };
    };
  };
}
