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
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "unstable";
    };

    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "unstable";
    };

    pkgs-wuz = {
      url = "./pkgs-wuz";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, nixpkgs, darwin, neovim, home-manager, ... }@inputs:
    with nixpkgs.lib;
    let
      # Recursively constructs an attrset of a given folder, recursing on directories, value of attrs is the filetype
      getDir = dir:
        mapAttrs (file: type:
          if type == "directory" then getDir "${dir}/${file}" else type)
        (builtins.readDir dir);

      # Collects all files of a directory as a list of strings of paths
      files = dir:
        collect isString
        (mapAttrsRecursive (path: type: concatStringsSep "/" path)
          (getDir dir));

      # Filters out directories that don't end with .nix or are this file, also makes the strings absolute
      nixFilesIn = dir:
        map (file: dir + "/${file}")
        (filter (file: hasSuffix ".nix" file && file != "default.nix")
          (files dir));
    in {
      darwinConfigurations."wuzsys" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          {
            nixpkgs.overlays = with inputs; [ neovim.overlay pkgs-wuz.overlay ];
          }
          home-manager.darwinModule
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          ({ pkgs, lib, ... }: {
            environment.shells = [ pkgs.zsh ];

            environment.systemPackages = with pkgs; [ zsh ];

            users.users.wuz = {
              name = "wuz";
              home = "/Users/wuz";
              shell = pkgs.zsh;
            };

            services = { nix-daemon.enable = true; };
            nixpkgs = { config = { allowUnfree = true; }; };
            nix = {
              package = pkgs.nix;
              extraOptions = ''
                system = aarch64-darwin
                max-jobs = auto
                extra-platforms = aarch64-darwin x86_64-darwin
                experimental-features = nix-command flakes
              '';
            };
          })
          ./modules/home.nix
          ./modules/packages.nix
          ./modules/optout.nix
        ];

      };
    };
}
