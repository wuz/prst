# Auto-detect the current hostname and run the right switch command
switch:
    #!/usr/bin/env bash
    HOST=$(hostname -s)
    case "$HOST" in
      spellbook)
        sudo nix run nix-darwin -- switch --flake .#spellbook
        ;;
      grimoire)
        sudo nix run nix-darwin -- switch --flake .#grimoire
        ;;
      tower)
        sudo nixos-rebuild switch --flake .#tower
        ;;
      *)
        echo "Unknown host: $HOST — run 'just spellbook', 'just grimoire', or 'just tower' explicitly"
        exit 1
        ;;
    esac

# Switch spellbook — work MacBook (darwin)
spellbook:
    sudo nix run nix-darwin -- switch --flake .#spellbook

# Switch grimoire — personal MacBook (darwin)
grimoire:
    sudo nix run nix-darwin -- switch --flake .#grimoire

# Build tower (NixOS/WSL) without switching
tower:
    nix build .#nixosConfigurations.tower.config.system.build.toplevel

# Switch tower (NixOS/WSL) — run on the tower machine
tower-switch:
    sudo nixos-rebuild switch --flake .#tower

# Visualize the spellbook derivation tree
tree-spellbook:
    nix run nixpkgs#nix-tree -- --derivation ~/.config/darwin#darwinConfigurations.spellbook.system

# Update all flake inputs (creates a new flake.lock)
update:
    nix flake update

# Update a single flake input, e.g.: just update-input nixpkgs
update-input input:
    nix flake update {{ input }}

# Check the flake for errors without building
check:
    nix flake check

# Format all files
fmt:
    nix fmt

# Collect garbage older than 30 days
gc:
    nix-collect-garbage --delete-older-than 30d
    sudo nix-collect-garbage --delete-older-than 30d

# Optimise the nix store (deduplicates identical files)
optimise:
    nix store optimise

# Bootstrap the sops age key on spellbook from your SSH key (run once after first switch)
bootstrap-sops:
    mkdir -p /var/lib/sops-nix
    ssh-to-age -private-key -i ~/.ssh/id_ed25519 | sudo tee /var/lib/sops-nix/key.txt
    sudo chmod 600 /var/lib/sops-nix/key.txt
    echo "sops age key bootstrapped at /var/lib/sops-nix/key.txt"

# Edit sops secrets for a host (e.g.: just secret spellbook)
secret host:
    sops secrets/hosts/{{ host }}.yaml

# Update the optout.nix hash from upstream do-not-track-cli
update-optout:
    #!/usr/bin/env bash
    set -euo pipefail
    NIXFILE="flake/programs/privacy.nix"
    URL="https://raw.githubusercontent.com/alloydwhitlock/do-not-track-cli/main/do_not_track.env"
    NEW_HASH=$(nix-prefetch-url "$URL" 2>/dev/null)
    CURRENT=$(grep 'sha256 = ' "$NIXFILE" | head -1 | sed 's/.*sha256 = "\(.*\)".*/\1/')
    if [ "$NEW_HASH" = "$CURRENT" ]; then
      echo "optout is already up to date ($CURRENT)"
      exit 0
    fi
    sed -i "" "s|sha256 = \"$CURRENT\"|sha256 = \"$NEW_HASH\"|" "$NIXFILE"
    echo "Updated optout hash: $CURRENT -> $NEW_HASH"
