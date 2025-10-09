{
  pkgs,
  user,
  inputs,
  ...
}:
let
  uid = 502;
in
{
  wsl.enable = true;
  ids.gids.nixbld = 350;
  imports = [
  ]
  ++ (import ../../modules/shared);
  services.nix-daemon.enable = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5;
  users.knownUsers = [ user.username ];
  users.users.${user.username} = {
    name = user.username;
    description = user.name;
    home = "/Users/${user.username}";
    shell = pkgs.${user.shell};
    uid = uid;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
  environment.systemPackages = with pkgs; [
    bash-completion
    bashInteractive
    blesh
    gcc
    curl
    gnugrep
    gnupg
    gnused
    gawk
    msgpack
    libiconvReal
    coreutils-full
    findutils
    diffutils
    moreutils
    libuv
    gnupg
    zsh

    shellcheck
    shellharden
    shfmt
    go
    ccmenu
  ];

  environment.pathsToLink = [
    "/share/bash-completion"
    "/share/zsh"
  ];

  programs.nix-index.enable = true;

  system = {
  };

  documentation.enable = false;
}
