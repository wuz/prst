{ lib, ... }:
let
  username = "wuz";
in
{
  personal.base.homeManager = { pkgs, ... }: {
    home.stateVersion = "24.05";
    home.username = username;
    home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    programs.home-manager.enable = true;
    xdg.enable = true;
  };

  personal.user.user.description = "Conlin Durbin";

  personal.user.includes = [
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
          uid = 501;
        };
      }
    )
  ];
}
