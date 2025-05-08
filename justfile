spellbook:
  nix -vvv --extra-experimental-features 'flakes nix-command' --accept-flake-config run nix-darwin -- switch --flake .#spellbook

tree-spellbook:
  nix run nixpkgs#nix-tree -- --derivation ~/.config/darwin#darwinConfigurations.spellbook.system

tower:
  nix build .#tower
