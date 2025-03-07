{
  description = "prst - wuz's configurator";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    nix-darwin-browsers.url = "github:wuz/nix-darwin-browsers";
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

    inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

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
      nix-darwin-browsers,
      determinate,
      ...
    }:
    let
      inherit (darwin.lib) darwinSystem;
      overlays = [
        neovim-nightly-overlay.overlays.default
        nur.overlays.default
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
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.${user.username} = ./hosts/spellbook/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.backupFileExtension = "backup";
          home-manager.sharedModules = [
          ];
        }
      ];
      wslModules = [
        { nixpkgs.overlays = overlays; }
        nixos-wsl.nixosModules.default
      ];
      darwinModules = [
        {
          nixpkgs.overlays = [
            nix-darwin-browsers.overlays.default
          ] ++ overlays;
        }
        determinate.darwinModules.default
        home-manager.darwinModules.home-manager
      ];
    in
    {
      darwinConfigurations = {
        spellbook = darwinSystem {
          system = "aarch64-darwin";
          modules =
            [
              ./hosts/spellbook
            ]
            ++ sharedModules
            ++ darwinModules;
          specialArgs = specialArgs;
        };
      };
      nixosConfigurations = {
        tower = {
          modules = [ ./hosts/tower ] ++ sharedModules ++ wslModules;
        };

      };
      darwinPackages = self.darwinConfigurations."spellbook".pkgs;
    };
}
