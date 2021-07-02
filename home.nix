{ config, pkgs, lib, ... }:
let
  inherit (pkgs.hax) isDarwin fetchFromGitHub;

  firstName = "Conlin";
  lastName = "Durbin";
  username = "wuz";
  personalEmail = "c@wuz.sh";
  workEmail = "conlin@hackerrank.com";
  home = (builtins.getEnv "HOME");
  user = (builtins.getEnv "USER");
  dots = "${home}/.alchemy";

  kwbauson-cfg = import <kwbauson-cfg>;

  waterfoxConfig = import ./defaults/waterfox;

in with pkgs.hax; {
  programs.home-manager.enable = true;

  home = {
    username = "conlindurbin";

    sessionVariables = {
      EDITOR = "vim";
      HISTCONTROL = "ignoredup";
      PAGER = "less";
      LESS = "-iR";
      BASH_SILENCE_DEPRECATION_WARNING = "1";
      CACHE = "~/.cache";
      GCC_COLORS =
        "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      MANROFFOPT = "-c";
      LDFLAGS = "-L/usr/local/opt/readline/lib";
      CPPFLAGS = "-I/usr/local/opt/readline/include";
    };

    packages = with pkgs;
      lib.flatten [
        (lib.optional isDarwin [
          (brewCaskDmg "insomnia"
            "1ygiirdpdjzv6jb9a7wpki35p9ikfw3s29jnigbcqb0k6jgmhgvw")
          (brewCaskDmg "slack"
            "0dwzl8gq0mb1bky51zyln90yp5i3wfv8d3b9hd7zba7q05w356n8")
          (brewCaskDmg "cleanshot"
            "1h53qlri71zbfwwgvrdj9lr6snqy1m2vhy3bi8ylwhp8yswj06wn")
          # (brewCaskDmg "muzzle"
          #   "1viikhkb4iqb5jkzhwj2j419wyp8q8qsv8vfqkc7spjv82ymm28w")
          (brewCaskDmg "alfred"
            "0dw16iq5qxj8zqwa79slvnbvfagyh68m30zzvd2v86a0d1x6rfl9")
          # (brewCaskDmg "karabiner-elements"
          #   "0dyhxlycplwya0zgqmhpvc6hn65b1b5b8rgfqh99dxhrls3w9li8")
          (brewCaskPkg "owncloud"
            "1mbni4hmcyk6xi09501159x2r13gkbqdgyh1zjgyv3g9xdd7nicb")
        ])
        (import (fetchTarball {
          url =
            "https://github.com/NixOS/nixpkgs/archive/266b6cdea3203ae0164c9974cfb4d58c6ff3b3fe.tar.gz";
          sha256 = "1c8fymvb5r8xhp55ckynzyrk731p9bnmfs0k4yxz0ykxz5hpf4p4";
        }) { }).wezterm
        act
        bandwhich
        bash_5
        bash-completion
        bashInteractive
        bat
        bottom
        coreutils-full
        curl
        delta
        diffutils
        dust
        exa
        exa
        fd
        figlet
        ruby
        nodejs
        yarn
        fzf
        gawk
        gh
        gitAndTools.delta
        gitAndTools.gh
        gnugrep
        gnupg
        gnused
        grex
        hyperfine
        # keybase
        kwbauson-cfg.better-comma
        kwbauson-cfg.git-trim
        kwbauson-cfg.nle
        luajit
        mcfly
        moreutils
        msgpack
        neovim-unwrapped
        ninja
        nix-bash-completions
        nixfmt
        nnn
        nushell
        openssh
        ssh-copy-id
        jq
        go
        procs
        pssh
        pup
        ranger
        rename
        ripgrep
        rsync
        cargo
        rustc
        rustfmt
        shellcheck
        tealdeer
        tmux
        tokei
        tree
        tree-sitter
        unzip
        waterfox
        wget
        zoxide
      ];

    activation = {
      copyApplications = let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        if [ -d "$baseDir" ]; then
          rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        for appFile in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$appFile")"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
        done
      '';
    };

    # file = {
    #   familiar = {
    #     target = ".config/familiar";
    #     source = "${dots}/familiar";
    #   };
    # };
  };

  programs.bash = {
    enable = true;
    inherit (config.home) sessionVariables;
    historyFileSize = -1;
    historySize = -1;
    shellAliases = {
      ".s" = "source ~/.bash_profile";
      hm = "home-manager";
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
    };
    initExtra = ''
      # Autocorrect typos in path names when using `cd`
      source ~/.nix-profile/etc/profile.d/nix.sh
      shopt -s cdspell
      # . "$HOME/.files/common/bashrc"

      PS1='$(familiar)'

      GPG_TTY=$(tty)
      export GPG_TTY

      source ~/.nix-profile/etc/profile.d/bash_completion.sh
      source ~/.nix-profile/share/bash-completion/completions/git
      source ~/.nix-profile/share/bash-completion/completions/ssh
      # complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

      eval "$(zoxide init bash)"

      # . $HOME/.asdf/asdf.sh
      # . $HOME/.asdf/completions/asdf.bash

      # . "$HOME/.local/share/lscolors.sh"

      # export KEYS_AUTH=`keys auth -token`
      export PATH="$PATH:~/.bin"
      export PATH="$PATH:Users/wuz/.local/share/gem/ruby/2.7.0/gems"

      function brewurl {
        echo "Looking for $1"
        curl "https://formulae.brew.sh/api/cask/$1.json" | jq
        echo "sha256"
        nix-prefetch-url "https://formulae.brew.sh/api/cask/$1.json"
      }
    '';
  };
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "${username}";
    userEmail = if isDarwin then workEmail else personalEmail;
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
        "stash list --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
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
      rpom = "!git pull --rebase && git pom # rebase and push to origin/master";
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
      core = {
        editor = "nvim";
        pager = "delta --dark";
      };
      rebase.instructionFormat = "<%ae >%s";
      commit = { gpgsign = true; };
    };
  };
  programs.git.signing = {
    key = "CAA69BFC5EF24C40";
    gpgPath = "gpg";
    signByDefault = true;
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.prefix-highlight
      tmuxPlugins.fzf-tmux-url
    ];
    baseIndex = 1;
    extraConfig = ''
      if-shell 'uname | grep -q Darwin' \
      'set-option -g default-command "reattach-to-user-namespace -l bash"' \

      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"
      set-option -g mouse on
      set-option -g status-keys vi
      set-option -g set-titles-string 'tmux - #W'
      set -g bell-action current
      set-option -g visual-bell off
      set-option -g set-clipboard off
      setw -g mode-keys vi
      setw -g monitor-activity on
      set -g visual-activity on
      set-option -g set-titles on
      set-option -g allow-rename off
      set-option -g renumber-windows on
      set -s escape-time 0
      set -g history-limit 10000
      set -g status-interval 1

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
      bind x if "tmux display -p \"#{window_panes}\" | grep ^1\$" \
      "confirm-before -p \"Kill the only pane in window? It will kill this window too! (y/n)\" kill-pane" \
      "kill-pane"
      bind -n M-x if "tmux display -p \"#{window_panes}\" | grep ^1\$" \
      "confirm-before -p \"Kill the only pane in window? It will kill this window too! (y/n)\" kill-pane" \
      "kill-pane"
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
      bind s last-pane # Press ctrl-s to go to last pane
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
      # Make new windows/panes open to the current path instead of the path tmux was started from
      unbind '"'
      unbind %
      bind - split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
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

      # ================================================================= plugins

      run '~/.tmux/plugins/tpm/tpm'
    '';
  };

  programs.mcfly.enable = true;

  programs.bat = {
    enable = true;
    config = {
      theme = "dankneon";
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
}
