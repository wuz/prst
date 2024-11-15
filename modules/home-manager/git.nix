{
  pkgs,
  config,
  lib,
  ...
}:
let
  signingEnabled = config.git.user.key != null;
in
{
  options.git.enable = lib.mkEnableOption "git";
  options.git.user = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "The name to use for git commits";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "The email to use for git commits";
    };
    key = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The GPG key to use for signing commits";
    };
  };
  config = lib.mkIf config.git.enable {
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
    home.packages = with pkgs; [
      git-town
      git-pull-status
    ];
    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "diff-so-fancy";
          };
          disableForcePushing = true;
        };
        gui = {
          language = "en";
          mouseEvents = false;
          sidePanelWidth = 0.3;
          mainPanelSplitMode = "flexible"; # one of "horizontal" | "flexible" | "vertical"
          showFileTree = false; # ` to toggle
          nerdFontsVersion = "3";
          commitHashLength = 6;
          showDivergenceFromBaseBranch = "arrowAndNumber";
          theme = {
            activeBorderColor = [
              "#ff966c"
              "bold"
            ];
            inactiveBorderColor = [ "#589ed7" ];
            searchingActiveBorderColor = [
              "#ff966c"
              "bold"
            ];
            optionsTextColor = [ "#82aaff" ];
            selectedLineBgColor = [ "#2d3f76" ];
            cherryPickedCommitFgColor = [ "#82aaff" ];
            cherryPickedCommitBgColor = [ "#c099ff" ];
            markedBaseCommitFgColor = [ "#82aaff" ];
            markedBaseCommitBgColor = [ "#ffc777" ];
            unstagedChangesColor = [ "#c53b53" ];
            defaultFgColor = [ "#c8d3f5" ];
          };
        };
        quitOnTopLevelReturn = true;
        disableStartupPopups = true;
        promptToReturnFromSubprocess = false;
        os = {
          edit = "nvim";
          editAtLine = "{{editor}} +{{line}} {{filename}}";
        };
        keybinding = {
          files = {
            stashAllChanges = "<c-a>"; # instead of just 's' which I typod for 'c'
          };
          universal = {
            prevItem = "e";
            nextItem = "n";
            scrollUpMain = "<up>"; # main panel scroll up
            scrollDownMain = "<down>"; # main panel scroll down
            nextMatch = "j";
            prevMatch = "J";
            new = "<c-a>";
            edit = "<c-r>";
          };
        };
        customCommands = [
          {
            key = "Y";
            context = "global";
            description = "Git-Town sYnc";
            command = "git-town sync --all";
            stream = true;
            loadingText = "Syncing";
          }
          {
            key = "U";
            context = "global";
            description = "Git-Town Undo (undo the last git-town command)";
            command = "git-town undo";
            prompts = [
              {
                type = "confirm";
                title = "Undo Last Command";
                body = "Are you sure you want to Undo the last git-town command?";
              }
            ];
            stream = true;
            loadingText = "Undoing Git-Town Command";
          }
          {
            key = "!";
            context = "global";
            description = "Git-Town Repo (opens the repo link)";
            command = "git-town repo";
            stream = true;
            loadingText = "Opening Repo Link";
          }
          {
            key = "a";
            context = "localBranches";
            description = "Git-Town Append";
            prompts = [
              {
                type = "input";
                title = ''
                  Enter name of new child branch. Branches off of
                        "{{.CheckedOutBranch.Name}}"'';
                key = "BranchName";
              }
            ];
            command = "git-town append {{.Form.BranchName}}";
            stream = true;
            loadingText = "Appending";
          }
          {
            key = "h";
            context = "localBranches";
            description = "Git-Town Hack (creates a new branch)";
            prompts = [
              {
                type = "input";
                title = ''Enter name of new branch. Branches off of "Main"'';
                key = "BranchName";
              }
            ];
            command = "git-town hack {{.Form.BranchName}}";
            stream = true;
            loadingText = "Hacking";
          }
          {
            key = "K";
            context = "localBranches";
            description = "Git-Town Kill (deletes the current feature branch and sYnc)";
            command = "git-town kill";
            prompts = [
              {
                type = "confirm";
                title = "Delete current feature branch";
                body = "Are you sure you want to delete the current feature branch?";
              }
            ];
            stream = true;
            loadingText = "Killing Feature Branch";
          }
          {
            key = "p";
            context = "localBranches";
            description = "Git-Town Propose (creates a pull request)";
            command = "git-town propose";
            stream = true;
            loadingText = "Creating pull request";
          }
          {
            key = "P";
            context = "localBranches";
            description = ''
              Git-Town Prepend (creates a branch between the curent branch
                and its parent)'';
            prompts = [
              {
                type = "input";
                title = ''
                  Enter name of the for child branch between
                        "{{.CheckedOutBranch.Name}}" and its parent'';
                key = "BranchName";
              }
            ];
            command = "git-town prepend {{.Form.BranchName}}";
            stream = true;
            loadingText = "Prepending";
          }
          {
            key = "S";
            context = "localBranches";
            description = "Git-Town Skip (skip branch with merge conflicts when syncing)";
            command = "git-town skip";
            stream = true;
            loadingText = "Skipping";
          }
          {
            key = "G";
            context = "files";
            description = ''
              Git-Town GO aka =continue (continue after resolving merge
                            conflicts)'';
            command = "git-town continue";
            stream = true;
            loadingText = "Continuing";
          }
        ];
      };
    };
    programs.git = {
      enable = true;
      userName = config.git.user.name;
      userEmail = config.git.user.email;
      delta = {
        enable = true;
        options = {
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-decoration-style = "none";
            file-style = "bold yellow ul";
          };
          features = "decorations";
          whitespace-error-style = "22 reverse";
          minus-style = ''syntax "#3a273a"'';
          minus-non-emph-style = ''syntax "#3a273a"'';
          minus-emph-style = ''syntax "#6b2e43"'';
          minus-empty-line-marker-style = ''syntax "#3a273a"'';
          line-numbers-minus-style = ''"#e26a75"'';
          plus-style = ''syntax "#273849"'';
          plus-non-emph-style = ''syntax "#273849"'';
          plus-emph-style = ''syntax "#305f6f"'';
          plus-empty-line-marker-style = ''syntax "#273849"'';
          line-numbers-plus-style = ''"#b8db87"'';
          line-numbers-zero-style = ''"#3b4261"'';
        };
      };
      lfs = {
        enable = true;
      };
      signing = {
        key = config.git.user.key;
        signByDefault = signingEnabled;
      };
      ignores = [ ".DS_Store" ];
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
        g = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        sl = "stash list --pretty='format:%<(13)%C(auto)%gd %C(green)%s %C(auto)|%C(yellow) %ar'";
        h = "!git --no-pager log origin/master..HEAD --abbrev-commit --pretty=oneline #pretty oneline graph of what is different from origin/master";
        pom = "!sh -c 'git h && echo Ready to push? ENTER && read && git push origin master' -";
        pomt = "!sh -c 'git h && echo Ready to push? ENTER && read && git push origin master && git push origin master --tags' -";
        purm = ''!sh -c 'test "$#" = 1 && git h && git checkout master && git pull --ff-only && git checkout "$1" && git rebase master && exit 0 || echo "usage: git purm <branch>" >&2 && exit 1' -'';
        rem = ''!sh -c 'test "$#" = 1 && git h && git checkout master && git pull --ff-only && git checkout "$1" && git rebase master && git checkout master && git merge "$1" && echo Done and ready to do: git pom && exit 0 || echo "usage: git rem <branch>" >&2 && exit 1' -'';
        rpom = "!git pull --rebase && git pom # rebase and push to origin/master";
        new = "hack";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        getr = "!git-pull-r";
        wipe = "!git-wipe";
        cmas = ''!f() { git commit -m "$1" --author="$2"; }; f'';
        coco = ''!f() { git commit -m ""$1" $(for i in "''${@:2}"; do echo "Co-authored-by: $i"; done);"; }; f'';
        rbc = "rebase --continue";
        rba = "rebase --abort";
        branchr = "!git-branch-r";
        track-upstream = "!sh -c 'git branch -u origin/$(git branch --show-current)'";
        lt = "!git describe $(git rev-list --tags --max-count=1) #list tags";
        ri = "!f() { if [ -z $1 ]; then val=$(git --no-pager log origin/master..HEAD --pretty=oneline | wc -l); else val=$1; fi; git rebase -i HEAD~$val; }; f";
        qc = "!git commit -a -m '____QUICK COMMIT - REMOVE WITH REBASE'";
        branch-name = "!git rev-parse --abbrev-ref HEAD";
        put = "!git push origin $(git branch-name)";
        pufl = "!git push origin $(git branch-name) --force-with-lease";
        get = "!git pull --ff-only";
        got = "!f() { CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) && git checkout $2 && git pull origin $1 --ff-only && git checkout $CURRENT_BRANCH;  }; f";
        who = "shortlog -n -s --no-merges";
        cleanup = "!git remote prune origin && git branch -vv | grep ': gone]' | cut -d ' ' -f 3 | xargs -n 1 git branch -D";
        fco = ''!f() { git branch -a -vv --color=always --format='%(refname)' | sed "s_refs/heads/__" | sed "s_refs/remotes/__" | fzf --query="$@" --height=40% --ansi --tac --color=16 --border | awk '{print $1}' | xargs git co; }; f'';
        lb = "!git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 10 | awk -F' ~ HEAD@{' '{printf(\"  \\033[33m%s: \\033[37      m %s\\033[0m\\n\", substr($2, 1, length($2)-1), $1)}'";
        append = "town append";
        compress = "town compress";
        contribute = "town contribute";
        diff-parent = "town diff-parent";
        hack = "town hack";
        kill = "town kill";
        observe = "town observe";
        park = "town park";
        prepend = "town prepend";
        propose = "town propose";
        rename-branch = "town rename-branch";
        repo = "town repo";
        set-parent = "town set-parent";
        ship = "town ship";
        sync = "town sync";
        tc = "town continue";
      };
      extraConfig = {
        color.ui = true;
        push.default = "current";
        pull.ff = "only";
        init.defaultBranch = "main";
        checkout.defaultRemote = "origin";
        core = {
          editor = "nvim";
        };
        rebase.instructionFormat = "<%ae >%s";
        commit = {
          gpgsign = true;
        };
        merge = {
          tool = "vimConflicted";
          conflictStyle = "diff3";
        };
        mergetool = {
          vimConflicted = {
            cmd = "vim +Conflicted";
          };
        };
      };
    };
  };
}
