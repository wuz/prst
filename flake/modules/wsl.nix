{ inputs, ... }:
{
  nodes.wsl = {
    nixos = {
      imports = [ inputs.nixos-wsl.nixosModules.default ];
    };
  };
}
