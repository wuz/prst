{
  description = "prst - wuz's configurator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pkgs-wuz = {
      url = "./pkgs-wuz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
  let
    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs.lib)
      attrValues makeOverridable optionalAttrs singleton;
    overlays = with inputs; [ pkgs-wuz.overlay ];
    configuration = { pkgs, lib, ... }: {
      nixpkgs = {
        config = { allowUnfree = true; };
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
        # spotify
        # discord
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

      users.users."wuz" = {
        name = "wuz";
        home = "/Users/wuz";
        shell = pkgs.bashInteractive;
      };

      programs.bash.enable = true;
      programs.nix-index.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
      system.defaults.NSGlobalDomain.KeyRepeat = 2;

      nix = {
        configureBuildUsers = true;
        settings = {
          experimental-features = "nix-command flakes";
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

      services.nix-daemon.enable = true;

      fonts.fontDir.enable = true;
      security.pam.enableSudoTouchIdAuth = true;
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
	  "keybase"
        ];
      };
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
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#prst
    darwinConfigurations."prst" = darwinSystem {
      system = "aarch64-darwin";
      modules = sharedModules ++ [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."prst".pkgs;
  };
}
