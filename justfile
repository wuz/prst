# Build and switch spellbook (darwin).
# --impure is required because inputs.self.dirtyRev is read on dirty git trees.
spellbook:
  sudo nix -vvv --extra-experimental-features 'flakes nix-command' --accept-flake-config run nix-darwin -- switch --impure --flake .#spellbook

# Visualize the spellbook derivation tree
tree-spellbook:
  nix run nixpkgs#nix-tree -- --derivation ~/.config/darwin#darwinConfigurations.spellbook.system

# Build tower (NixOS/WSL) without switching
tower:
  nix build .#nixosConfigurations.tower.config.system.build.toplevel

# Update all flake inputs (creates a new flake.lock)
update:
  nix flake update

# Update a single flake input, e.g.: just update-input nixpkgs
update-input input:
  nix flake lock --update-input {{input}}

# Check the flake for errors without building
check:
  nix flake check

# Collect garbage older than 30 days
gc:
  nix-collect-garbage --delete-older-than 30d
  sudo nix-collect-garbage --delete-older-than 30d

# Optimise the nix store (deduplicates identical files)
optimise:
  nix store optimise
