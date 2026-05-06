# Pulls telemetry opt-out variables from upstream:
# https://github.com/alloydwhitlock/do-not-track-cli/blob/main/do_not_track.env
#
# To update the hash: run `nix-prefetch-url https://raw.githubusercontent.com/alloydwhitlock/do-not-track-cli/main/do_not_track.env`
# and replace the sha256 below.
{ lib, ... }:
let
  envFile = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/alloydwhitlock/do-not-track-cli/main/do_not_track.env";
    sha256 = "1d64ppqpfs02s86lbnfjy9i5gc2fq7cpcnv3wxs4lcwsgna1018m";
  };

  parseLine =
    line:
    let
      stripped = lib.strings.removeSuffix "\r" line;
      isComment = lib.strings.hasPrefix "#" stripped || stripped == "";
      parts = lib.strings.splitString "=" stripped;
      key = builtins.head parts;
      value = lib.strings.concatStringsSep "=" (builtins.tail parts);
      validKey = builtins.match "[A-Z][A-Z0-9_]*" key != null;
    in
    if isComment || builtins.length parts < 2 || !validKey then
      null
    else
      {
        name = key;
        inherit value;
      };

  lines = lib.strings.splitString "\n" (builtins.readFile envFile);
  parsed = builtins.filter (x: x != null) (map parseLine lines);
  sessionVars = builtins.listToAttrs parsed;
in
{
  prst.optout = {
    homeManager = {
      home.sessionVariables = sessionVars;
    };
  };
}
