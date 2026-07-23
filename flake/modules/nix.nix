{ lib, ... }: {
  nodes.nix = {
    os = { lib, ... }: {
      nix.settings = {
        nix-path = [ "nixpkgs=flake:nixpkgs" ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        extra-trusted-users = [
          "conlin.durbin"
          "@admin"
          "@wheel"
        ];
        trusted-users = [
          "conlin.durbin"
          "@admin"
          "@wheel"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://rycee.cachix.org"
          "https://cachix.cachix.org"
          "https://nix-community.cachix.org"
          "https://wuz.cachix.org"
          "https://whatnot-inc.cachix.org"
          "https://jacobi.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
          "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
          "whatnot-inc.cachix.org-1:ypC6uahOlaZp+EYUmBD0wclRBlGwDBBnmFTesV4CgWs="
          "wuz.cachix.org-1:cvFztsdv6usx0iXXs9tbskFTxaozacGaE4WG1uW6W1M="
          "jacobi.cachix.org-1:JJghCz+ZD2hc9BHO94myjCzf4wS3DeBLKHOz3jCukMU="
          "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        # Performance tuning
        http-connections = 128;
        max-substitution-jobs = 128;
        connect-timeout = 5;
        fallback = true;
        warn-dirty = false;
      };

      # NOTE: auto-optimise-store is intentionally disabled on macOS due to
      # https://github.com/NixOS/nix/issues/7273 — run `nix store optimise` manually.
      nix.settings.auto-optimise-store = lib.mkDefault false;

      # Weekly GC — keep 30 days of generations
      nix.gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };

      nix.optimise.automatic = false;
    };

    darwin = {
      nix.settings.system-features = [
        "nixos-test"
        "apple-virt"
      ];
      nix.gc.interval = {
        Weekday = 0; # Sunday
        Hour = 2;
        Minute = 0;
      };
      nix.linux-builder.enable = false;
    };

    nixos = {
      nix.settings.auto-optimise-store = lib.mkForce true; # Safe on Linux
      nix.gc.dates = "Sun 02:00";
    };
  };
}
