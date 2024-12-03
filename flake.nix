{
  description = "prst - wuz's configurator";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    pog.url = "github:jpetrucciani/pog";
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # pkgs-wuz = {
    #   url = "github:wuz/prst/main?dir=pkgs-wuz";
    # };
    pkgs-wuz = {
      url = "./pkgs-wuz";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    floorp-darwin = {
      url = "github:wuz/floorp-nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jacobi = {
      url = "github:jpetrucciani/nix";
      # inputs = {
      #   nixpkgs.follows = "nixpkgs";
      # };
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

    liminix = {
      flake = false;
      url = "https://gti.telent.net/dan/liminix";
    };
  };

  outputs =
    inputs@{
      self,
      darwin,
      home-manager,
      nur,
      pkgs-wuz,
      neovim-nightly-overlay,
      jacobi,
      nixos-wsl,
      ...
    }:
    let
      inherit (darwin.lib) darwinSystem;
      overlays = [
        neovim-nightly-overlay.overlays.default
        nur.overlay
        pkgs-wuz.overlay
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
          ;
      };
      sharedModules = [
        nur.nixosModules.nur
        nur.hmModules.nur
        { nixpkgs.overlays = overlays; }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.${user.username} = ./hosts/spellbook/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
      wslModules = [
        nixos-wsl.nixosModules.default
      ];
      darwinModules = [
        home-manager.darwinModules.home-manager
      ];
    in
    {
      darwinConfigurations = {
        spellbook = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/spellbook
          ] ++ sharedModules ++ darwinModules;
          specialArgs = specialArgs;
        };
      };
      nixosConfigurations = {
        tower = {
          modules = [ ./hosts/tower ] ++ sharedModules ++ wslModules;
        };

      };
      # liminixConfigurations = {
      #   aether = { config, lib, pkgs, ... }: {};
      # };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."spellbook".pkgs;
    };
}
