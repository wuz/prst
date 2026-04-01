{
  pkgs,
  user,
  inputs,
  system-overlays,
  ...
}:
let
  uid = 1000;
in
{
  wsl.enable = true;
  imports = [ ] ++ (import ../../modules/shared);
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = "24.11";
  users.users.${user.username} = {
    isNormalUser = true;
    description = user.name;
    home = "/home/${user.username}";
    shell = pkgs.${user.shell};
    uid = uid;
    extraGroups = [ "wheel" ];
  };
  nixpkgs = {
    overlays = system-overlays "x86_64-linux";
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
  environment.systemPackages = with pkgs; [
    bash-completion
    bashInteractive
    gcc
    curl
    gnugrep
    gnupg
    gnused
    gawk
    msgpack-c
    libiconvReal
    coreutils-full
    findutils
    diffutils
    moreutils
    libuv
    zsh

    shellcheck
    shellharden
    shfmt
    go
  ];

  environment.pathsToLink = [
    "/share/bash-completion"
    "/share/zsh"
  ];

  programs.nix-index.enable = true;

  documentation.enable = false;
}
