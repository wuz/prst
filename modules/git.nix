{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  personalEmail = "conlindurbin@protonmail.com";
  workEmail = "";
  username = "wuz";
in {
  home-manager.users."wuz" = {
    programs.gh = {
      enable = true;
      settings = {
        prompt = "enabled";
        git_protocol = "ssh";
        editor = "vim";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };
    # programs.gh-dash = {
    #   enable = true;
    #   settings = {
    #     prSections = [{
    #       title = "My Pull Requests";
    #       filters = "is:open author:@me";
    #     }];
    #   };
    # };
    programs.git = {
      enable = true;
      userName = "${username}";
      userEmail = personalEmail;
      delta = { enable = true; };
      lfs = { enable = true; };
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
