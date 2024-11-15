{
  description = "prst - wuz's configurator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    pog.url = "github:jpetrucciani/pog";
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pkgs-wuz = {
      url = "github:wuz/prst?dir=pkgs-wuz";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-darwin = {
      url = "github:atahanyorganci/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jacobi = {
      url = "github:jpetrucciani/nix";
      # inputs = {
      #   nixpkgs.follows = "nixpkgs";
      # };
    };
    kwb = {
      url = "github:kwbauson/cfg";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    inputs@{
      self,
      darwin,
      home-manager,
      nur,
      firefox-addons,
      pkgs-wuz,
      neovim-nightly-overlay,
      jacobi,
      ...
    }:
    let
      inherit (darwin.lib) darwinSystem;
      overlays = [
        pkgs-wuz.overlay
        neovim-nightly-overlay.overlays.default
        nur.overlay
      ];
      user = {
        name = "Conlin Durbin";
        email = "c@wuz.sh";
        username = "conlin.durbin";
        shell = "zsh";
        key = "CAA69BFC5EF24C40";
      };
      specialArgs = {
        inherit
          user
          inputs
          firefox-addons
          jacobi
          ;
      };
      darwinModules = [
        nur.nixosModules.nur
        ./hosts/spellbook
        home-manager.darwinModules.home-manager
        { nixpkgs.overlays = overlays; }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.${user.username} = ./hosts/spellbook/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    in
    {
      darwinConfigurations."prst" = darwinSystem {
        system = "aarch64-darwin";
        modules = darwinModules;
        specialArgs = specialArgs;
      };
      darwinConfigurations."Whatnot-MacBook-Pro-16-inch-2023-T521X73XYX-2" = darwinSystem {
        system = "aarch64-darwin";
        modules = darwinModules;
        specialArgs = specialArgs;
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."prst".pkgs;
    };
}
