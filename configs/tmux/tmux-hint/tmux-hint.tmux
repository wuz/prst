#!/usr/bin/env bash
# tmux-hint plugin entry point.
# Sourced by tmux on startup (via run-shell in tmux.conf).

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HINT_SH="$PLUGIN_DIR/tmux-hint.sh"
CONFIG_DIR="$HOME/.config/tmux/tmux-hint"
CONFIG="$CONFIG_DIR/which-key.yaml"

# Expose config path as a tmux option
tmux set-option -gq @tmux-hint-config "$CONFIG"
tmux set-option -gq @tmux-hint-script "$HINT_SH"

# Bind prefix+? to open the hint popup
# Width/height chosen to give a comfortable hint panel
tmux bind-key -T prefix '?' \
    display-popup \
        -E \
        -w 80% \
        -h 40% \
        -x C \
        -y S \
        -e "TMUX_HINT_CONFIG=$CONFIG" \
        "bash '$HINT_SH'"
