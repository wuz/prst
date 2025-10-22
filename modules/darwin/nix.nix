{
  user,
  lib,
  pkgs,
  config,
  ...
}:
let
in
{
  nix.extraOptions = ''
    !include ${config.age.secrets.github-access-token.path}
  '';
  nix.settings = {
    nix-path = [ "nixpkgs=flake:nixpkgs" ];
    experimental-features = "nix-command flakes";

    extra-trusted-users = [
      user.username
      "@admin"
    ];
    trusted-users = [
      user.username
      "@admin"
    ];
    system-features = [
      "nixos-test"
      "apple-virt"
    ];
    substituters = [
      # "https://wuz.cachix.org"
      # "https://jacobi.cachix.org"
      # "https://whatnot-inc.cachix.org"
      "https://rycee.cachix.org"
      "https://cachix.cachix.org"
      # "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
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
  };
  nix.linux-builder = {
    enable = false;
  };
}
