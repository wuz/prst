{
  description = "prst - wuz's configurator";

  nixConfig = {
    trusted-substituters = [
      "https://wuz.cachix.org"
      "https://jacobi.cachix.org"
      "https://whatnot-inc.cachix.org"
      "https://rycee.cachix.org"
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "whatnot-inc.cachix.org-1:ypC6uahOlaZp+EYUmBD0wclRBlGwDBBnmFTesV4CgWs="
      "wuz.cachix.org-1:cvFztsdv6usx0iXXs9tbskFTxaozacGaE4WG1uW6W1M="
      "jacobi.cachix.org-1:JJghCz+ZD2hc9BHO94myjCzf4wS3DeBLKHOz3jCukMU="
      "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    pog.url = "github:jpetrucciani/pog";
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
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
