{
  description = "prst - wuz's configurator";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    ragenix.url = "github:yaxitech/ragenix";

    pog.url = "github:jpetrucciani/pog";
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-search.url = "github:diamondburned/nix-search";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pkgs-wuz = {
      url = "github:wuz/prst/main?dir=pkgs-wuz";
    };
    # pkgs-wuz = {
    #   url = "git+file://~/.config/darwin?dir=pkgs-wuz";
    # };

    zen-browser = {
      url = "github:wuz/zen-browser-flake";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    claude-code.url = "github:sadjow/claude-code-nix";
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
      jacobi,
      nixos-wsl,
      claude-code,
      ragenix,
      zen-browser,
      ...
    }:
    let
      inherit (darwin.lib) darwinSystem;
      overlays = [
        nur.overlays.default
        pkgs-wuz.overlays.default
        claude-code.overlays.default
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
        { nixpkgs.overlays = overlays; }
        nixos-wsl.nixosModules.default
      ];
      darwinModules = [
        {
          nixpkgs.overlays = [
          ]
          ++ overlays;
        }
        {
          home-manager.backupFileExtension = "backup";
          home-manager.users.${user.username} = ./hosts/spellbook/home.nix;
        }
        home-manager.darwinModules.home-manager
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
        tower = {
          modules = [ ./hosts/tower ] ++ sharedModules ++ wslModules;
        };

      };
      darwinPackages = self.darwinConfigurations."spellbook".pkgs;
    };
}
