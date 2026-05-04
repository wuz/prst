{ lib, ... }:
let
  username = "conlin.durbin";
in
{
  # Base home-manager config — included by every host via conlin.base in den.aspects."conlin.durbin"
  conlin.base.homeManager =
    { pkgs, ... }:
    {
      home.stateVersion = "24.05";
      home.username = username;
      home.homeDirectory =
        if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
      programs.home-manager.enable = true;
      xdg.enable = true;
    };

  # OS-level user account config.
  conlin.user.user.description = "Conlin Durbin";

  conlin.user.includes = [
    (
      { host, ... }:
      lib.optionalAttrs (host.class == "nixos") {
        user = {
          isNormalUser = true;
          uid = 1000;
          extraGroups = [ "wheel" ];
          home = "/home/${username}";
        };
      }
    )
    (
      { host, ... }:
      lib.optionalAttrs (host.class == "darwin") {
        user = {
          name = username;
          home = "/Users/${username}";
          uid = 502;
        };
      }
    )
  ];
}
