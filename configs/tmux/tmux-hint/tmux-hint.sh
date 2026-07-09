#!/usr/bin/env bash
# tmux-hint: launches the interactive hint popup and executes the chosen command.

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON="${PYTHON:-python3}"
CONFIG="${TMUX_HINT_CONFIG:-$HOME/.config/tmux/tmux-hint/which-key.yaml}"

OUT="$(mktemp /tmp/tmux-hint-out.XXXXXX)"
trap 'rm -f "$OUT"' EXIT

TMUX_HINT_CONFIG="$CONFIG" \
TMUX_HINT_OUT="$OUT" \
"$PYTHON" "$PLUGIN_DIR/tmux-hint.py"

if [[ -s "$OUT" ]]; then
    CMD="$(cat "$OUT")"
    # Commands from the YAML are tmux command strings (same syntax as tmux.conf).
    # Semicolons separate chained commands (tmux's ';' separator).
    # Split on ' ; ' and run each command as a separate tmux invocation.
    IFS=';' read -ra PARTS <<< "$CMD"
    for part in "${PARTS[@]}"; do
        part="${part#"${part%%[! ]*}"}"  # ltrim
        part="${part%"${part##*[! ]}"}"  # rtrim
        [[ -z "$part" ]] && continue
        eval "tmux $part" 2>/dev/null || true
    done
fi
