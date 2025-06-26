{
  pkgs,
  config,
  lib,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };

  himalaya-modified = pkgs.himalaya.override {
    withFeatures = [ "keyring" ];
  };
  himalayaConfig = {
    accounts = {
      proton = {
        default = true;
        backend = {
          type = "imap";
          host = "127.0.0.1";
          port = 1143;
          login = "conlind@proton.me";
          auth = {
            keyring = "proton";
          };
        };
        message.send.backend = {
          type = "smtp";
          host = "127.0.0.1";
          port = 1025;
          login = "conlind@proton.me";
          auth = {
            keyring = "proton";
          };
        };
      };
    };
  };
in
{
  options.himalaya.enable = lib.mkEnableOption "himalaya";
  options.himalaya.user = {
    email = lib.mkOption {
      type = lib.types.str;
      description = "";
    };
    display-name = lib.mkOption {
      type = lib.types.str;
      description = "";
    };
    downloads-dir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "";
    };
  };
  config = lib.mkIf config.himalaya.enable {
    home.packages = [
      himalaya-modified
    ];
    xdg.configFile."himalaya/config.toml".source =
      tomlFormat.generate "himalaya-config.toml" himalayaConfig;
  };
}
