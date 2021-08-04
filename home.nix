{ config, pkgs, lib, ... }:

let
  inherit (pkgs.hax) isDarwin fetchFromGitHub;

  firstName = "Conlin";
  lastName = "Durbin";
  username = "wuz";
  personalEmail = "c@wuz.sh";
  workEmail = "conlin@figurehr.com";
  home = (builtins.getEnv "HOME");
  user = (builtins.getEnv "USER");
  dots = "${home}/.alchemy";

in with pkgs.hax; {
  imports = [ ./home/packages.nix ./home/optout.nix ./home/tmux.nix ];
  programs.home-manager.enable = true;

  home = {
    username = "wuz";

    sessionVariables = {
      EDITOR = "nvim";
      HISTCONTROL = "ignoredup";
      PAGER = "less";
      LESS = "-iR";
      BASH_SILENCE_DEPRECATION_WARNING = "1";
      CACHE = "~/.cache";
      GCC_COLORS =
        "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      MANROFFOPT = "-c";
    };
  };

  programs.bash = {
    enable = true;
    inherit (config.home) sessionVariables;
    historyFileSize = -1;
    historySize = -1;
    shellAliases = {
      ".s" = "source ~/.bash_profile";
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
    };
    initExtra = ''
      # Autocorrect typos in path names when using `cd`
      source ~/.nix-profile/etc/profile.d/nix.sh
      shopt -s cdspell


      GPG_TTY=$(tty)
      export GPG_TTY

      source ~/.nix-profile/etc/profile.d/bash_completion.sh
      source ~/.nix-profile/share/bash-completion/completions/git
      source ~/.nix-profile/share/bash-completion/completions/ssh
      # complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

      eval "$(zoxide init bash)"


      # export KEYS_AUTH=`keys auth -token`
      export PATH="$PATH:~/.bin"
      export PATH="$PATH:Users/wuz/.local/share/gem/ruby/2.7.0/gems"

      export PS1="\$(familiar)"

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

  programs.mcfly.enable = true;

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
}
