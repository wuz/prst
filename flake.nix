{
  description = "prst - wuz's configurator";

  nixConfig.extra-substituters = "https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys =
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    unstable.url = "github:nixos/nixpkgs";
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

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    with nixpkgs.lib;
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib)
        attrValues makeOverridable optionalAttrs singleton;
      overlays = with inputs; [ pkgs-wuz.overlay ];
      configuration = { pkgs, ... }: {
        system.stateVersion = 4;
        documentation.enable = false;
        homebrew = {
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
          ];
        };
      };
      sharedModules = [
        { nixpkgs.overlays = overlays; }
        ./modules/configuration.nix
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
