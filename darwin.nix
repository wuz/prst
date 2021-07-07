{ config, pkgs, ... }:

let home           = builtins.getEnv "HOME";
in {
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";
  imports = [ 
    <home-manager/nix-darwin>
    ./darwin/system.nix
    ./darwin/brew.nix
  ];

  users = {
    users.wuz = {
      name = "wuz";
      home = "/Users/wuz";
    };
  };

  services = {
    nix-daemon.enable = false;
    lorri.enable = true;
  };

  nix = {
    nixPath = [{
      darwin-config   = "${home}/.config/nixpkgs/darwin.nix";
      ssh-config-file = "${home}/.ssh/config";
    }];
    useDaemon = false;
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
