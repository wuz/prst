{
  description = "prst - wuz's configurator";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    ragenix.url = "github:yaxitech/ragenix";

    pog.url = "github:jpetrucciani/pog";
    nur.url = "github:nix-community/NUR";

    nix-search.url = "github:diamondburned/nix-search";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    direnv-instant.url = "github:Mic92/direnv-instant";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    jacobi = {
      url = "github:jpetrucciani/nix";
    };
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwb = {
      url = "github:kwbauson/cfg";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # liminix = {
    #   flake = false;
    #   url = "https://gti.telent.net/dan/liminix";
    # };

  };

  outputs =
    inputs@{
      self,
      darwin,
      home-manager,
      nur,
      jacobi,
      nixos-wsl,
      ragenix,
      pog,
      nix-homebrew,
      ...
    }:
    let
      inherit (darwin.lib) darwinSystem;
      system-overlays = system: [
        nur.overlays.default
        pog.overlays.${system}.default
        (import ./overlays)
        ragenix.overlays.default
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
          jacobi
          system-overlays
          ;
      };
      sharedModules = [
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.backupFileExtension = "backup";
        }
        ragenix.nixosModules.default
      ];
      wslModules = [
        nixos-wsl.nixosModules.default
      ];
      darwinModules = [
        {
          home-manager.users.${user.username} = ./hosts/spellbook/home.nix;
        }
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
      ];
    in
    {
      darwinConfigurations = {
        spellbook = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/spellbook
          ]
          ++ sharedModules
          ++ darwinModules;
          specialArgs = specialArgs;
        };
      };
      nixosConfigurations = {
        tower = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/tower ] ++ sharedModules ++ wslModules;
          specialArgs = specialArgs;
        };
      };
      darwinPackages = self.darwinConfigurations."spellbook".pkgs;
    };
}
