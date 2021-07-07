{ config, pkgs, lib, ... }:
let
  inherit (pkgs.hax) isDarwin fetchFromGitHub;

  firstName = "Conlin";
  lastName = "Durbin";
  username = "wuz";
  personalEmail = "c@wuz.sh";
  workEmail = "conlin@figurehr.com";
  home = (builtins.getEnv "HOME");
  user = (builtins.getEnv "USER");

  kwbauson-cfg = import (fetchFromGitHub {
    owner = "kwbauson";
    repo = "cfg";
    rev = "1cd4b9097516358844f1d75551ad514dcf435011";
    sha256 = "0vp1fwqwkn3x5sr57gcrc3ippjyx6c7a8whfp0dqax7wfmd5nznv";
  });

in with pkgs.hax; {
  programs.home-manager.enable = true;

  home = {
    username = "wuz";

    sessionVariables = {
      EDITOR = "vim";
      HISTCONTROL = "ignoredup";
      PAGER = "less";
      LESS = "-iR";
      BASH_SILENCE_DEPRECATION_WARNING = "1";
      CACHE = "~/.cache";
      GCC_COLORS =
        "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      MANROFFOPT = "-c";
      LDFLAGS = "-L/usr/local/opt/readline/lib";
      CPPFLAGS = "-I/usr/local/opt/readline/include";
    };

    packages = with pkgs; [
       zoxide
       zsh
      ];
  };
  programs.zsh.enable = true;
  programs.bash.enable = false;
}
