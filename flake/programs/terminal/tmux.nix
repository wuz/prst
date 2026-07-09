# tmux is retained as a lightweight fallback for SSH sessions where zmx is
# not installed on the remote host. It is no longer the primary workflow —
# Ghostty native splits/tabs + zmx handle local session management.
{ ... }:
{
  work.tmux = {
    homeManager =
      { pkgs, ... }:
      {
        programs.tmux = {
          enable = true;
          prefix = "C-a";
          terminal = "tmux-256color";
          mouse = true;
          keyMode = "vi";
          baseIndex = 1;
          escapeTime = 0;
          historyLimit = 50000;
          sensibleOnTop = true;
          plugins = with pkgs.tmuxPlugins; [
            resurrect
            continuum
          ];
          extraConfig = ''
            # Minimal config — splits, copy mode, clipboard
            set -g detach-on-destroy off
            set -s focus-events on
            set -g set-clipboard on
            set -g renumber-windows on

            bind | split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"
            unbind '"'
            unbind %
            bind c new-window -c "#{pane_current_path}"

            bind -T copy-mode-vi v send-keys -X begin-selection
            bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

            set -as terminal-features ",xterm-ghostty:RGB"
            set -as terminal-overrides ',*:Tc'
          '';
        };
      };
  };
}
