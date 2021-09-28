{ config, pkgs, lib, ... }:

let home = builtins.getEnv "HOME";
in {
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";
  imports = [ <home-manager/nix-darwin> ./darwin/system.nix ./darwin/brew.nix ];
  environment.shells = [ pkgs.zsh ];

  users = {
    users.wuz = {
      name = "wuz";
      home = "/Users/wuz";
      shell = pkgs.zsh;
    };
  };

  services = {
    nix-daemon.enable = false;
    postgresql.enable = true;
  };

  nix = {
    useDaemon = false;
    extraOptions = ''
      system = x86_64-darwin
      max-jobs = auto
      extra-platforms = x86_64-darwin aarch64-darwin
      extra-substituters = https://figurehr-figure.cachix.org
    '';
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
