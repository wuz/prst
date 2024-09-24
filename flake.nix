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
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib)
        attrValues makeOverridable optionalAttrs singleton;
      overlays = with inputs; [
        pkgs-wuz.overlay
        inputs.neovim-nightly-overlay.overlays.default
      ];
      configuration = { pkgs, lib, ... }: {
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

        environment.shells = [ pkgs.bashInteractive pkgs.zsh ];

        users.users."conlin.durbin" = {
          name = "conlin.durbin";
          home = "/Users/conlin.durbin";
          shell = pkgs.zsh;
        };

        programs.bash.enable = false;
        programs.zsh.enable = true;
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

        security.pam.enableSudoTouchIdAuth = true;
        documentation.enable = false;
        homebrew = {
          enable = true;
          brews = [ "libiconv" ];
          casks = [
            # "arc"
            "setapp"
            "affinity-designer"
            "affinity-photo"
            "affinity-publisher"
            "betterdisplay"
            "figma"
            "appcleaner"
            "obsidian"
            "muzzle"
            "karabiner-elements"
            "notion-calendar"
            "obsidian"
            "protonvpn"
            "spotify"
            # "wezterm"
            "whatsapp"
            "transmission"
            "elgato-control-center"
            "elgato-wave-link"
            "little-snitch"
            "micro-snitch"
            "docker"
            "keybase"
            "discord"
          ];
        };
      };
      sharedModules = [
        {
          nixpkgs.overlays = overlays;
        }
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
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#prst
      darwinConfigurations."prst" = darwinSystem {
        system = "aarch64-darwin";
        modules = sharedModules ++ [ configuration ];
      };
      darwinConfigurations."Whatnot-MacBook-Pro-16-inch-2023-T521X73XYX-2" =
        darwinSystem {
          system = "aarch64-darwin";
          modules = sharedModules ++ [ configuration ];
        };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."prst".pkgs;
    };
}
