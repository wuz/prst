{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs) fetchFromGithub;
  inherit (pkgs.stdenv) isDarwin;
  personalEmail = "c@wuz.sh";
  workEmail = "conlin@figurehr.com";
  username = "wuz";
in {
  home-manager.users.wuz = {

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
        'set-option -g default-command "reattach-to-user-namespace -l $SHELL"' \

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

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.mcfly={
      enable = true;
      enableZshIntegration = true;
      keyScheme = "vim";
    };
    programs.zoxide.enable = true;
    programs.starship.enable = true;
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      autocd = true;
      zplug = { 
        enable = true;
        plugins = [
          # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
        ];
      };
      shellAliases = {
        ".s" = "source ~/.zshrc";
        hm = "home-manager";
        dr = "darwin-rebuild";
        vim = "nvim";
        vi = "nvim";
        add = "git add -A";
        cm = "git cm";
        l = "exa -alFT --header -L 1";
        lg = "exa -alT -L 1 --header --git";
        ll = "exa -al";
        ls = "exa";
        lsd = "exa -lF | grep --color=never '^d'";
        cleanup = "find . -type f -name '*.DS_Store' -ls -delete";
        gogh =
          "wget -O gogh https://git.io/vQgMr && chmod +x gogh && ./gogh && rm gogh";
        b64 = "base64 -w 0 | pbcopy";
        cat = "bat";
        nixclean = "nix-collect-garbage -d";
        strip = ''
          sed -E 's#^\s+|\s+$##g'
        '';

        # nix
        nix_hash = "nix-prefetch-url";
        nix_hash_git = "nix-prefetch-git";

        # docker
        d = "docker";
        dall = "docker ps -a";
        dimg = "docker images";
        dexc = "docker exec -it";
        drun = "docker run --rm -it";
        drma = "docker stop $(docker ps -aq) && docker rm -f $(docker ps -aq)";
        drmi = "di | grep none | awk '{print $3}' | sponge | xargs docker rmi";
      };
      initExtraFirst = ''
        [ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
      '';
      initExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
        source /Users/wuz/.iterm2_shell_integration.zsh
        DISABLE_MAGIC_FUNCTIONS=true
        ZSH_AUTOSUGGEST_MANUAL_REBIND=1
        COMPLETION_WAITING_DOTS=true
        DISABLE_UNTRACKED_FILES_DIRTY=true
        export PATH="$PATH:/etc/profiles/per-user/wuz/bin:/usr/local/bin"
        [ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
      '';
    };
    programs.gpg = {
      enable = true;
    };
    programs.bat = {
      enable = true;
      config = {
        theme = "DankNeon";
        italic-text = "always";
        style = "numbers,changes";
      };
      themes = {
        DankNeon = builtins.readFile (pkgs.fetchFromGitHub {
          owner = "DankNeon";
          repo = "sublime"; # Bat uses sublime syntax for its themes
          rev = "31dd0216c33225cde3968f882dca0ad1375bc4e3";
          sha256 = "1xla6qln6fj123q92si59va90syn3fjkn4ynps42fvawyx1n4rld";
        } + "/Dank_Neon.tmTheme");
      };
    };
    programs.gh.enable = true;
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "${username}";
      userEmail = if isDarwin then workEmail else personalEmail;
      delta = { enable = true; };
      signing = {
        key = "CAA69BFC5EF24C40";
        gpgPath = "gpg";
        signByDefault = true;
      };
      aliases = {
        A = "add -A";
        cam = "commit -am";
        ca = "commit -a";
        cm = "commit -m";
        ci = "commit";
        co = "checkout";
        st = "status";
        br = "branch -v";
        unstage = "reset HEAD --";
        find = "!sh -c 'git ls-tree -r --name-only HEAD | grep --color $1' -";
        g =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        sl =
          "stash list --pretty='format:%<(13)%C(auto)%gd %C(green)%s %C(auto)|%C(yellow) %ar'";
        h =
          "!git --no-pager log origin/master..HEAD --abbrev-commit --pretty=oneline #pretty oneline graph of what is different from origin/master";
        pom =
          "!sh -c 'git h && echo Ready to push? ENTER && read && git push origin master' -";
        pomt =
          "!sh -c 'git h && echo Ready to push? ENTER && read && git push origin master && git push origin master --tags' -";
        purm = ''
          !sh -c 'test "$#" = 1 && git h && git checkout master && git pull --ff-only && git checkout "$1" && git rebase master && exit 0 || echo "usage: git purm <branch>" >&2 && exit 1' -'';
        rem = ''
          !sh -c 'test "$#" = 1 && git h && git checkout master && git pull --ff-only && git checkout "$1" && git rebase master && git checkout master && git merge "$1" && echo Done and ready to do: git pom && exit 0 || echo "usage: git rem <branch>" >&2 && exit 1' -'';
        rpom =
          "!git pull --rebase && git pom # rebase and push to origin/master";
        new = "checkout -b";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        getr = "!git-pull-r";
        wipe = "!git-wipe";
        cmas = ''!f() { git commit -m "$1" --author="$2"; }; f'';
        coco = ''
          !f() { git commit -m ""$1" $(for i in "''${@:2}"; do echo "Co-authored-by: $i"; done);"; }; f'';
        rbc = "rebase --continue";
        rba = "rebase --abort";
        branchr = "!git-branch-r";
        track-upstream =
          "!sh -c 'git branch -u origin/$(git branch --show-current)'";
        lt = "!git describe $(git rev-list --tags --max-count=1) #list tags";
        ri =
          "!f() { if [ -z $1 ]; then val=$(git --no-pager log origin/master..HEAD --pretty=oneline | wc -l); else val=$1; fi; git rebase -i HEAD~$val; }; f";
        qc = "!git commit -a -m '____QUICK COMMIT - REMOVE WITH REBASE'";
        branch-name = "!git rev-parse --abbrev-ref HEAD";
        put = "!git push origin $(git branch-name)";
        pufl = "!git push origin $(git branch-name) --force-with-lease";
        get = "!git pull --ff-only";
        got =
          "!f() { CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) && git checkout $2 && git pull origin $1 --ff-only && git checkout $CURRENT_BRANCH;  }; f";
        who = "shortlog -n -s --no-merges";
        cleanup =
          "!git remote prune origin && git branch -vv | grep ': gone]' | cut -d ' ' -f 3 | xargs -n 1 git branch -D";
        fco = ''
          !f() { git branch -a -vv --color=always --format='%(refname)' | sed "s_refs/heads/__" | sed "s_refs/remotes/__" | fzf --query="$@" --height=40% --ansi --tac --color=16 --border | awk '{print $1}' | xargs git co; }; f'';
        lb =
          "!git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 10 | awk -F' ~ HEAD@{' '{printf(\"  \\033[33m%s: \\033[37      m %s\\033[0m\\n\", substr($2, 1, length($2)-1), $1)}'";
      };
      extraConfig = {
        color.ui = true;
        push.default = "current";
        pull.ff = "only";
        init.defaultBranch = "main";
        checkout.defaultRemote = "origin";
        core = { editor = "nvim"; };
        rebase.instructionFormat = "<%ae >%s";
        commit = { gpgsign = true; };
        merge = { tool = "vimConflicted"; };
        mergetool = { vimConflicted = { cmd = "vim +Conflicted"; }; };
      };
    };
  };
}
