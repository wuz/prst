{ pkgs, user, inputs, lib, ... }:
let uid = 502;
in {
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
  nix.gc.interval = [{
    Hour = 2;
    Weekday = 0;
  }];
  # Add custom overlay for Firefox on MacOS.
  # Enable entering sudo mode with Touch ID.
  # Set Git commit hash for darwin-version.
  system.configurationRevision =
    inputs.self.rev or inputs.self.dirtyRev or null;
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
  nixpkgs = { config = { allowUnfree = true; }; };
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
    nixfmt
  ];

  environment.pathsToLink = [ "/share/bash-completion" "/share/zsh" ];

  programs.nix-index.enable = true;

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  nix = {
    configureBuildUsers = true;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "@admin" ];
    };
    linux-builder.enable = true;
    extraOptions = ''
      system = aarch64-darwin
      max-jobs = auto
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  security.pam.enableSudoTouchIdAuth = true;
  documentation.enable = false;
}

