{ config, pkgs, lib, ... }:

with lib;
let
  inherit (pkgs.hax) isDarwin fetchFromGitHub;

  firstName = "Conlin";
  lastName = "Durbin";

  username = "wuz";

  personalEmail = "c@wuz.sh";
  workEmail = "conlin@figurehr.com";

  home = (builtins.getEnv "HOME");
  user = (builtins.getEnv "USER");

  # Recursively constructs an attrset of a given folder, recursing on directories, value of attrs is the filetype
  getDir = dir:
    mapAttrs
    (file: type: if type == "directory" then getDir "${dir}/${file}" else type)
    (builtins.readDir dir);

  # Collects all files of a directory as a list of strings of paths
  files = dir:
    collect isString
    (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  # Filters out directories that don't end with .nix or are this file, also makes the strings absolute
  nixFilesIn = dir:
    map (file: dir + "/${file}")
    (filter (file: hasSuffix ".nix" file && file != "default.nix") (files dir));

in with pkgs.hax; {
  nixpkgs.overlays = import ./overlays.nix;
  imports = nixFilesIn ./home;
  programs.home-manager.enable = true;

  home = {
    sessionPath = [ "${home}/.bin" ];
    username = "wuz";

    sessionVariables = {
      EDITOR = "nvim";
      HISTCONTROL = "ignoredup";
      PAGER = "less";
      LESS = "-iR";
      CACHE = "~/.cache";
      GCC_COLORS =
        "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      MANROFFOPT = "-c";
    };
  };

  programs.direnv.enable = true;
  programs.mcfly.enable = true;
  programs.zoxide.enable = true;
  programs.starship.enable = true;
}
