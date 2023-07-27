{
  description = "prst - wuz's configurator";

  nixConfig.extra-substituters = "https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys =
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    pkgs-wuz = {
      url = "./pkgs-wuz";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    with nixpkgs.lib;
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib)
        attrValues makeOverridable optionalAttrs singleton;
      overlays = with inputs; [ pkgs-wuz.overlay ];
      configuration = {pkgs, lib, ...}: {
  # Nix configuration ------------------------------------------------------------------------------
  nix.configureBuildUsers = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  documentation.enable = false;
  homebrew = {
    enable = true;
    casks = [
      "setapp"
      "affinity-designer"
      "affinity-photo"
      "appcleaner"
      "obsidian"
      "muzzle"
      "elgato-wave-link"
      "little-snitch"
      "micro-snitch"
      "docker"
    ];
  };


  services.nix-daemon.enable = true;

  nixpkgs = {
    config = { allowUnfree = true; };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      substituters = [ "https://cache.nixos.org/" ];
      trusted-public-keys =
        [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      trusted-users = [ "@admin" ];
    };
    extraOptions = ''
      	system = aarch64-darwin
      	max-jobs = auto
        auto-optimise-store = true
        experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
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
    msgpack
    libiconv
    coreutils-full
    findutils
    diffutils
    moreutils
    libuv
    gnupg
    zsh
    spotify
    discord
    pinentry_mac
    nodejs_20
    shellcheck
    shellharden
    shfmt
    yarn
    rustc
    rustfmt
    cargo
    go
    ruby_3_0
    rubocop
    nixfmt
  ];

  environment.shells = [ pkgs.bashInteractive ];

  users.users."conlin.durbin" = {
     name = "conlin.durbin";
     home = "/Users/conlin.durbin";
     shell = pkgs.bashInteractive;
  };

  programs.nix-index.enable = true;
  programs.bash.enable = true;

  # environment.etc = {
  #   "davmail.properties" = {
  #     enable = true;
  #     source = ../config/davmail/davmail.properties;
  #   };
  # };
  # environment.launchAgents = {
  #   "com.nixos.davmail.plist" = {
  #     enable = true;
  #     text = ''
  #             [<?xml version="1.0" encoding="UTF-8"?>
  #       <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  #       <plist version="1.0">
  #       <dict>
  #           <key>Label</key>
  #           <string>davmail</string>
  #           <key>RunAtLoad</key>
  #           <true/>
  #           <key>ProgramArguments</key>
  #           <array>
  #               <string>/etc/profiles/per-user/wuz/bin/davmail</string>
  #               <string>/etc/davmail.properties</string>
  #           </array>
  #       </dict>
  #       </plist>
  #     '';
  #   };
  #   "com.nixos.offlineimap.plist" = {
  #     enable = true;
  #     text = ''
  #             [<?xml version="1.0" encoding="UTF-8"?>
  #       <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  #       <plist version="1.0">
  #       <dict>
  #           <key>Label</key>
  #           <string>offlineimap</string>
  #           <key>RunAtLoad</key>
  #           <true/>
  #           <key>ProgramArguments</key>
  #           <array>
  #               <string>/etc/profiles/per-user/wuz/bin/offlineimap</string>
  #           </array>
  #       </dict>
  #       </plist>
  #     '';
  #   };
  # };


  # # https://github.com/nix-community/home-manager/issues/423
  environment.variables = { OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES"; };
  #
  # # Fonts
  fonts.fontDir.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
      };
      sharedModules = [
        { nixpkgs.overlays = overlays; }
        # ./modules/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
        ./modules/home.nix
        ./modules/git.nix
        # ./modules/email.nix
        ./modules/shell.nix
        ./modules/packages.nix
        ./modules/optout.nix
      ];
    in {
      darwinConfigurations."prst" = darwinSystem {
        system = "aarch64-darwin";
        modules = sharedModules ++ [ configuration ];
      };
      darwinConfigurations."PS-MAC-CDURBIN" = darwinSystem {
        system = "aarch64-darwin";
        modules = sharedModules ++ [ configuration ];
      };
      darwinPackages = self.darwinConfigurations."prst".pkgs;
    };
}
