{ ... }:
{
  prst.git = {
    homeManager =
      { pkgs, ... }:
      {
        programs.gh-dash.enable = true;
        programs.gh = {
          enable = true;
          extensions = with pkgs; [
            gh-notify
            gh-s
            gh-poi
            gh-worktree
          ];
          settings = {
            prompt = "enabled";
            git_protocol = "ssh";
            editor = "vim";
            aliases = {
              co = "pr checkout";
              pv = "pr view";
              prco = "!f() { gh worktree pr \"$1\" \"$(git rev-parse --show-toplevel)/.worktrees\"; }; f";
            };
          };
        };
        home.packages = with pkgs; [
          git-town
          git-pull-status
          diff-so-fancy
          mergiraf
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
              mainPanelSplitMode = "flexible";
              showFileTree = false;
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
              files.stashAllChanges = "<c-a>";
              universal = {
                prevItem = "e";
                nextItem = "n";
                scrollUpMain = "<up>";
                scrollDownMain = "<down>";
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
                    title = ''Enter name of new child branch. Branches off of "{{.CheckedOutBranch.Name}}"'';
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
                    title = "Enter name of new branch";
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
                command = "git-town delete";
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
                key = "P";
                context = "localBranches";
                description = "Git-Town Prepend (creates a branch between the current branch and its parent)";
                prompts = [
                  {
                    type = "input";
                    title = ''Enter name of the for child branch between "{{.CheckedOutBranch.Name}}" and its parent'';
                    key = "BranchName";
                  }
                ];
                command = "git-town prepend {{.Form.BranchName}}";
                stream = true;
                loadingText = "Prepending";
              }
              {
                key = "p";
                context = "localBranches";
                description = "Git-Town Propose";
                command = "git-town propose";
                stream = true;
                loadingText = "Creating pull request";
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
                description = "Git-Town GO aka continue (continue after resolving merge conflicts)";
                command = "git-town continue";
                stream = true;
                loadingText = "Continuing";
              }
            ];
          };
        };
        programs.git.attributes = [ "* merge=mergiraf" ];
        programs.difftastic.git = {
          enable = true;
          diffToolMode = true;
        };
        programs.delta.enable = false;
        programs.git = {
          enable = true;
          lfs.enable = true;
          signing = {
            key = "CAA69BFC5EF24C40";
            signByDefault = true;
            format = "openpgp";
          };
          ignores = [ ".DS_Store" ];
          settings = {
            user = {
              name = "Conlin Durbin";
              email = "conlin.durbin@whatnot.com";
            };
            color.ui = true;
            push.default = "current";
            pull.ff = "only";
            init.defaultBranch = "main";
            checkout.defaultRemote = "origin";
            core.editor = "nvim";
            diff.tool = "nvimdiff";
            git-town = {
              sync-feature-strategy = "rebase";
              sync-perennial-strategy = "rebase";
            };
            rebase.instructionFormat = "<%ae >%s";
            commit.gpgsign = true;
            merge = {
              conflictStyle = "diff3";
              mergiraf = {
                name = "mergiraf";
                driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
              };
            };
            alias = {
              qc = "!git commit -a -m '____QUICK COMMIT - REMOVE WITH REBASE'";
              st = "status";
              co = "checkout";
              fco = "!f() { git branch -a -vv --color=always --format='%(refname)' | sed \"s_refs/heads/__\" | sed \"s_refs/remotes/__\" | fzf --query=\"$@\" --height=40% --ansi --tac --color=16 --border | awk '{print $1}' | xargs git co; }; f";
              got = "!f() { CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) && git checkout $2 && git pull origin $1 --ff-only && git checkout $CURRENT_BRANCH; }; f";
              get = "!git pull --ff-only";
              branch-name = "!git rev-parse --abbrev-ref HEAD";
              put = "!git push origin $(git branch-name)";
              pufl = "!git push origin $(git branch-name) --force-with-lease";
              br = "branch -v";
              fix-conflict = "jump merge *";
              ri = "!f() { if [ -z $1 ]; then val=$(git --no-pager log origin/master..HEAD --pretty=oneline | wc -l); else val=$1; fi; git rebase -i HEAD~$val; }; f";
              rbc = "rebase --continue";
              rba = "rebase --abort";
              sl = "stash list --pretty='format:%<(13)%C(auto)%gd %C(green)%s %C(auto)|%C(yellow) %ar'";
              lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
              lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
              h = "!git --no-pager log origin/master..HEAD --abbrev-commit --pretty=oneline";
              who = "shortlog -n -s --no-merges";
              unstage = "reset HEAD --";
              cleanup = "!git remote prune origin && git branch -vv | grep ': gone]' | cut -d ' ' -f 3 | xargs -n 1 git branch -D";
              g = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
              track-upstream = "!sh -c 'git branch -u origin/$(git branch --show-current)'";
              lt = "!git describe $(git rev-list --tags --max-count=1)";
              lb = "!git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 10 | awk -F' ~ HEAD@{' '{printf(\"  \\033[33m%s: \\033[37m %s\\033[0m\\n\", substr($2, 1, length($2)-1), $1)}'";
              cm = "commit -m";
              cmas = "!f() { git commit -m \"$1\" --author=\"$2\"; }; f";
              coco = ''!f() { git commit -m "$1 $(for i in "''${@:2}"; do echo "Co-authored-by: $i"; done)"; }; f'';
              append = "town append";
              prepend = "town prepend";
              compress = "town compress";
              diff-parent = "town diff-parent";
              hack = "town hack";
              new = "town hack";
              delete = "town delete";
              observe = "town observe";
              park = "town park";
              propose = "town propose";
              rename = "town rename";
              repo = "town repo";
              set-parent = "town set-parent";
              ship = "town ship";
              sync = "town sync";
              switch = "town switch";
              tc = "town continue";
            };
          };
        };
      };
  };
}
