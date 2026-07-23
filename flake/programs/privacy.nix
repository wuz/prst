# Telemetry opt-out variables, vendored from upstream:
# https://github.com/alloydwhitlock/do-not-track-cli/blob/main/do_not_track.env
#
# To update: run `just update-optout` (re-downloads do_not_track.env).
# Vendoring avoids a network fetch during evaluation.
{ lib, ... }:
let
  envFile = ./do_not_track.env;

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
  work.optout = {
    homeManager = {
      home.sessionVariables = sessionVars;
    };
  };
}
