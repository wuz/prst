{ config, pkgs, ... }:

let home = builtins.getEnv "HOME";
in {
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";
  imports = [ <home-manager/nix-darwin> ./darwin/system.nix ./darwin/brew.nix ];

  users = {
    users.wuz = {
      name = "wuz";
      home = "/Users/wuz";
      shell = pkgs.bash_5;
    };
  };

  services = {
    nix-daemon.enable = false;
    postgresql.enable = true;
  };

  nix = {
    nixPath = [{
      darwin-config = "${home}/.config/nixpkgs/darwin.nix";
      ssh-config-file = "${home}/.ssh/config";
    }];
    useDaemon = false;
    extraOptions = ''
      max-jobs = auto
      extra-platforms = aarch64-darwin
    '';
    # extra-substituters = https://figurehr-figure.cachix.org
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowInsecure = false;
      allowUnsupportedSystem = false;
    };
  };

  home-manager.users.wuz = import ./home.nix;
  system.stateVersion = 4;
}
