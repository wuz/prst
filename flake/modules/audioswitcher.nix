{ ... }:
let
  homeDir = "/private/var/lib/audioswitcher";
in
{
  nodes.audioswitcher = {
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.audio-switcher-d ];
        launchd.daemons.audioswitcher = {
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
  };
}
