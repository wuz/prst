{
  config,
  pkgs,
  user,
  inputs,
  lib,
  ...
}:
let
  uid = 502;
in
{
  imports = [
    ../../modules/darwin/firefox.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/shell.nix
  ];
  # Disable `nix-darwin` documentation
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # Necessary for using flakes on this system.
  # Run garbage collection automatically every Sunday at 2am.
  nix.gc.automatic = true;
  nix.gc.interval = [
    {
      Hour = 2;
      Weekday = 0;
    }
  ];
  # Add custom overlay for Firefox on MacOS.
  # Enable entering sudo mode with Touch ID.
  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  # Ensures compatibility with defaults from NixOS
  system.stateVersion = 4;
  # Users managed by Nix
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
    # spotify
    # discord
    pinentry_mac
    nodejs_22
    corepack_22
    shellcheck
    shellharden
    shfmt
    yarn
    rustc
    rustfmt
    cargo
    go
    ruby_3_3
    rubocop
    nixfmt-rfc-style
  ];

  environment.pathsToLink = [
    "/share/bash-completion"
    "/share/zsh"
  ];

  programs.nix-index.enable = true;

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  nix = {
    configureBuildUsers = true;
    settings = {
      experimental-features = "nix-command flakes";
      extra-trusted-users = [
        user.username
        "@admin"
      ];
      trusted-users = [ "@admin" ];
      substituters = [
        "https://cache.nixos.org"
        "https://cache.nixos.org/"
        "https://whatnot-inc.cachix.org"
        "https://wuz.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "whatnot-inc.cachix.org-1:ypC6uahOlaZp+EYUmBD0wclRBlGwDBBnmFTesV4CgWs="
        "wuz.cachix.org-1:cvFztsdv6usx0iXXs9tbskFTxaozacGaE4WG1uW6W1M="
      ];
    };
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      config = {
        nix.settings.sandbox = false;
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
      };
    };
    extraOptions =
      ''
        system = aarch64-darwin
        max-jobs = auto
        auto-optimise-store = true
        experimental-features = nix-command flakes
      ''
      + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
  };

  security.pam.enableSudoTouchIdAuth = true;
  documentation.enable = false;
}
