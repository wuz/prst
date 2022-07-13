{
  description = "prst - wuz's configurator";

  nixConfig.extra-substituters = "https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys =
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/master";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };

    # neovim = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.url = "github:nixos/nixpkgs?rev=fad51abd42ca17a60fc1d4cb9382e2d79ae31836";
    # };

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
      overlays = with inputs;
        [
          # neovim.overlay
          pkgs-wuz.overlay
        ];
    in
    {
      darwinConfigurations = {
        prst = darwinSystem {
          system = "aarch64-darwin";
          modules = self.sharedModules ++ [ ];
        };
        "PS-MAC-CDURBIN" = darwinSystem {
          system = "aarch64-darwin";
          modules = self.sharedModules ++ [ ];
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
        ./modules/email.nix
        ./modules/zsh.nix
        # ./modules/tmux.nix
        ./modules/packages.nix
        ./modules/optout.nix
      ];
      darwinPackages = self.darwinConfigurations."prst".pkgs;
    };
}
