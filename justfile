spellbook:
  nix run nix-darwin -- switch --flake .#spellbook

tower:
  nix build .#tower
