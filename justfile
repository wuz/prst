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

# Update duckypad to the latest GitHub release version
update-duckypad:
  #!/usr/bin/env bash
  set -euo pipefail
  NIXFILE="modules/darwin/duckypad.nix"
  LATEST=$(curl -fsSL https://api.github.com/repos/duckyPad/duckyPad-Configurator/releases/latest | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/')
  CURRENT=$(grep 'version = ' "$NIXFILE" | head -1 | sed 's/.*version = "\(.*\)".*/\1/')
  if [ "$LATEST" = "$CURRENT" ]; then
    echo "duckypad is already at the latest version ($CURRENT)"
    exit 0
  fi
  echo "Updating duckypad: $CURRENT -> $LATEST"
  URL="https://github.com/duckyPad/duckyPad-Configurator/releases/download/${LATEST}/duckypad_config_${LATEST}_source.zip"
  RAW_HASH=$(nix-prefetch-url --type sha256 --unpack "$URL" 2>/dev/null)
  NEW_HASH=$(nix hash convert --hash-algo sha256 --to sri "$RAW_HASH" 2>/dev/null)
  sed -i "s|version = \"$CURRENT\"|version = \"$LATEST\"|" "$NIXFILE"
  sed -i "s|sha256 = \"sha256-.*\"|sha256 = \"$NEW_HASH\"|" "$NIXFILE"
  echo "Updated to $LATEST with hash $NEW_HASH"

# Update the optout.nix hash from upstream do-not-track-cli
update-optout:
  #!/usr/bin/env bash
  set -euo pipefail
  NIXFILE="modules/home-manager/other/optout.nix"
  URL="https://raw.githubusercontent.com/alloydwhitlock/do-not-track-cli/main/do_not_track.env"
  NEW_HASH=$(nix-prefetch-url "$URL" 2>/dev/null)
  CURRENT=$(grep 'sha256 = ' "$NIXFILE" | head -1 | sed 's/.*sha256 = "\(.*\)".*/\1/')
  if [ "$NEW_HASH" = "$CURRENT" ]; then
    echo "optout.nix is already up to date ($CURRENT)"
    exit 0
  fi
  sed -i "" "s|sha256 = \"$CURRENT\"|sha256 = \"$NEW_HASH\"|" "$NIXFILE"
  echo "Updated optout.nix hash: $CURRENT -> $NEW_HASH"
