{
  user,
  lib,
  pkgs,
  ...
}:
let
in
{
  nix.gc.automatic = true;
  nix.gc.interval = [
    {
      Hour = 2;
      Weekday = 0;
    }
  ];
  nix.optimise.automatic = true;
  nix.configureBuildUsers = true;
  nix.settings = {
    nix-path = [ "nixpkgs=flake:nixpkgs" ];
    experimental-features = "nix-command flakes";
    extra-trusted-users = [
      user.username
      "@admin"
    ];
    trusted-users = [
      user.username
      "@admin"
    ];
    netrc-file = "/Users/${user.username}/.config/nix/netrc";
    substituters = [
      "https://cache.nixos.org"
      "https://whatnot-inc.cachix.org"
      "https://wuz.cachix.org"
      "https://jacobi.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "whatnot-inc.cachix.org-1:ypC6uahOlaZp+EYUmBD0wclRBlGwDBBnmFTesV4CgWs="
      "wuz.cachix.org-1:cvFztsdv6usx0iXXs9tbskFTxaozacGaE4WG1uW6W1M="
      "jacobi.cachix.org-1:JJghCz+ZD2hc9BHO94myjCzf4wS3DeBLKHOz3jCukMU="
    ];
  };
  nix.linux-builder = {
    package = pkgs.darwin.linux-builder;
    enable = false;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };

  # Enable logging for the linux builder
  launchd.daemons.linux-builder = {
    serviceConfig = {
      StandardOutPath = "/var/log/darwin-builder.log";
      StandardErrorPath = "/var/log/darwin-builder.log";
    };
  };
  nix.extraOptions =
    ''
      builders-use-substitutes = true
      system = aarch64-darwin
      max-jobs = auto
      auto-optimise-store = true
      experimental-features = nix-command flakes
    ''
    + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
}
