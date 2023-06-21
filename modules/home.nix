{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs) fetchFromGithub;
  inherit (pkgs.stdenv) isDarwin;
  personalEmail = "c@wuz.sh";
  workEmail = "conlin@getagora.com";
  username = "wuz";
in
{
  home-manager.users.wuz = {
    home = {
      stateVersion = "22.11";
      sessionVariables = {
        EDITOR = "vim";
      };
    };
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.mcfly = {
      enable = true;
      enableZshIntegration = true;
      keyScheme = "vim";
    };
    programs.zoxide.enable = true;
    programs.neovim = {
      enable = true;
    };
    programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$all"
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];
        directory = {
          style = "blue";
        };
        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };
        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
        };
        git_state = {
          format = "([$state( $progress_current/$progress_total)]($style))";
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
      };
      # Starship is broken on the current version for mac
      # package = (import (builtins.fetchGit {
      #     name = "nixpkgs-starship-old";
      #     url = https://github.com/nixos/nixpkgs/;
      #     rev = "cc2a7c2943364eee1be6c6eb2c83a856b7f39f34";
      #   }) {}).starship;
    };
    programs.zathura.enable = true;
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
        DankNeon = builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "DankNeon";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "31dd0216c33225cde3968f882dca0ad1375bc4e3";
            sha256 = "1xla6qln6fj123q92si59va90syn3fjkn4ynps42fvawyx1n4rld";
          } + "/Dank_Neon.tmTheme");
      };
    };
  };
}
