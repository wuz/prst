{ ... }:
{
  conlin.git = {
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
                key = "h";
                context = "localBranches";
                description = "Git-Town Hack";
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
                key = "p";
                context = "localBranches";
                description = "Git-Town Propose";
                command = "git-town propose";
                stream = true;
                loadingText = "Creating pull request";
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
              email = "c@wuz.sh";
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
              get = "!git pull --ff-only";
              put = "!git push origin $(git branch-name)";
              pufl = "!git push origin $(git branch-name) --force-with-lease";
              br = "branch -v";
              branch-name = "!git rev-parse --abbrev-ref HEAD";
              lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
              lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
              g = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
              cm = "commit -m";
              append = "town append";
              prepend = "town prepend";
              hack = "town hack";
              new = "town hack";
              delete = "town delete";
              propose = "town propose";
              sync = "town sync";
              switch = "town switch";
              tc = "town continue";
              cleanup = "!git remote prune origin && git branch -vv | grep ': gone]' | cut -d ' ' -f 3 | xargs -n 1 git branch -D";
            };
          };
        };
      };
  };
}
