{ config, pkgs, lib, ... }:
with pkgs.hax; {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    tmuxp = { enable = true; };
    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.prefix-highlight
      tmuxPlugins.fzf-tmux-url
    ];
    terminal = "xterm-256color";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    extraConfig = ''
      # =============
      # general setup
      # =============

      # handle mac copy/paste weirdness
      if-shell 'uname | grep -q Darwin' \
      'set-option -g default-command "reattach-to-user-namespace -l bash"' \

      # mouse mode
      set -g mouse on

      # =============
      # popup windows
      # =============

      # bind keys to open a floating window
      # bind-key 

      # annoying bells go bye bye
      set -g bell-action current
      set-option -g visual-bell off
      set-option -g set-clipboard off
      setw -g monitor-activity on
      set -g visual-activity on

      # ======================
      # better pane management
      # ======================

      # unbind original split keys
      unbind '"'
      unbind %

      # bind - and | to split
      bind - split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      # bind c to open a new window
      bind c new-window -c "#{pane_current_path}"

      # Press ctrl-s to go to last pane
      bind s last-pane 

      # ----------------------------------------------------------

      set-option -g renumber-windows on
      set -g status-interval 1

      # kill the window
      bind x if "tmux display -p \"#{window_panes}\" | grep ^1\$" \
      "confirm-before -p \"Kill the only pane in window? It will kill this window too! (y/n)\" kill-pane" \
      "kill-pane"
      bind -n M-x if "tmux display -p \"#{window_panes}\" | grep ^1\$" \
      "confirm-before -p \"Kill the only pane in window? It will kill this window too! (y/n)\" kill-pane" \
      "kill-pane"

      bind-key -n M-n new-window -c "#{pane_current_path}"
      bind-key -n M-1 select-window -t :1
      bind-key -n M-2 select-window -t :2
      bind-key -n M-3 select-window -t :3
      bind-key -n M-4 select-window -t :4
      bind-key -n M-5 select-window -t :5
      bind-key -n M-6 select-window -t :6
      bind-key -n M-7 select-window -t :7
      bind-key -n M-8 select-window -t :8
      bind-key -n M-9 select-window -t :9
      bind-key -n M-0 select-window -t :0
      bind-key -n M-. select-window -n
      bind-key -n M-, select-window -p
      bind-key -n M-< swap-window -t -1
      bind-key -n M-> swap-window -t +1
      bind-key -n M-R command-prompt -I "" "rename-window '%%'"
      bind-key -n M-f resize-pane -Z
      bind-key -n M-h select-pane -L
      bind-key -n M-l select-pane -R
      bind-key -n M-k select-pane -U
      bind-key -n M-j select-pane -D
      bind-key -n M-Left select-pane -L
      bind-key -n M-Right select-pane -R
      bind-key -n M-Up select-pane -U
      bind-key -n M-Down select-pane -D
      bind-key -n "M-H" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -L; tmux swap-pane -t $old'
      bind-key -n "M-J" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -D; tmux swap-pane -t $old'
      bind-key -n "M-K" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -U; tmux swap-pane -t $old'
      bind-key -n "M-L" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -R; tmux swap-pane -t $old'
      bind-key -n "M-S-Left" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -L; tmux swap-pane -t $old'
      bind-key -n "M-S-Down" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -D; tmux swap-pane -t $old'
      bind-key -n "M-S-Up" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -U; tmux swap-pane -t $old'
      bind-key -n "M-S-Right" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -R; tmux swap-pane -t $old'
      bind-key -n M-x confirm-before "kill-pane"
      bind-key -n M-/ copy-mode
      bind C-a last-window # Press C-a again to go to last window
      bind r source-file ~/.tmux.conf \; display "Reloaded!" # Reload the file with Prefix r.
      # Vimlike copy mode.
      bind Escape copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
      # bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      unbind-key -T copy-mode-vi Enter
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      unbind p
      bind p paste-buffer
      # Splitting panes.
      # Moving between panes.
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      # Moving between windows.
      unbind [
      unbind ]
      bind -r [ select-window -t :-
      bind -r ] select-window -t :+
      # Pane resizing.
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      # Maximize and restore a pane.
      unbind Up
      bind Up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp
      unbind Down
      bind Down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp
      # Log output to a text file on demand.
      bind P pipe-pane -o "cat >>~/#W.log" \; display "Toggled logging to ~/#W.log"
      bind-key -n Home send Escape "OH"
      bind-key -n End send Escape "OF"

      # ================================================================= window titles
      set -g window-status-current-format "#[fg=black]#[bg=brightmagenta] #I #[bg=brightblack]#[fg=brightwhite] #W #[fg=brightblack]#[bg=black]"
      set -g window-status-format "#[fg=brightwhite]#[bg=brightblack] #I#[bg=brightblack]#[fg=brightwhite] #W #[fg=brightblack]#[bg=black]"

      # ================================================================= status bar
      set-option -g status-position bottom
      set-option -g status-justify left
      set -g status-fg colour9
      set -g status-bg colour0
      set -g status-left \'\'
      set -g status-right '#(date +"%_I:%M") | c:#(isvpn) |'

      # ================================================================= message bar

      set -g message-style bg=colour5,fg=colour0
    '';
  };
}
