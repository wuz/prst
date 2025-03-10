spellbook:
  nix -vvv --extra-experimental-features 'flakes nix-command' run nix-darwin -- switch --flake .#spellbook

tower:
  nix build .#tower
