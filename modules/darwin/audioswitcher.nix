{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.services.audioswitcher;
  homeDir = "/private/var/lib/audioswitcher";
in
{
  options = {
    services.audioswitcher = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the audioswitcher Daemon.";
      };
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts = {
      launchd = mkIf cfg.enable {
        text = lib.mkBefore '''';
      };
    };
    environment.systemPackages = [ pkgs.audio-switcher-d ];
    launchd.daemons.audioswitcher = {
      path = [ config.environment.systemPath ];

      serviceConfig = {
        KeepAlive = true;
        Label = "dev.nix.audioswitcher";
        ProgramArguments = [ "${pkgs.audio-switcher-d}" ];
        RunAtLoad = true;
        StandardErrorPath = "${homeDir}/log/err.log";
        StandardOutPath = "${homeDir}/log/out.log";
      };
    };
  };
}
