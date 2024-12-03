{
  config,
  lib,
  ...
}:
let
  signingEnabled = config.jj.user.key != null;
in
{
  options.jj.enable = lib.mkEnableOption "jj";
  options.jj.user = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "The name to use for jj commits";
    };
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username to use for jj prefixes";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "The email to use for jj commits";
    };
    key = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The GPG key to use for signing commits";
    };
  };
  config = lib.mkIf config.jj.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = config.jj.user.name;
          email = config.jj.user.email;
        };
        git.push-bookmark-prefix = "${config.jj.user.username}/push-";
        signing = {
          key = config.jj.user.key;
          signAll = signingEnabled;
        };
      };
    };
  };
}
