{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let inherit (pkgs) fetchFromGithub;
in {
  home-manager.users.wuz = {
    programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$all"
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];
        directory = { style = "blue"; };
        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };
        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };
        git_status = {
          format =
            "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
        };
        git_state = {
          format = "([$state( $progress_current/$progress_total)]($style))";
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
      };
      # Starship is broken on the current version for mac
      # package = (import (builtins.fetchGit {
      #     name = "nixpkgs-starship-old";
      #     url = https://github.com/nixos/nixpkgs/;
      #     rev = "cc2a7c2943364eee1be6c6eb2c83a856b7f39f34";
      #   }) {}).starship;
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = false;
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
        nixsearch = "nix-env -qaP | grep -i $1";
        strip = ''
          sed -E 's#^\s+|\s+$##g'
        '';

        # docker
        d = "docker";
        dall = "docker ps -a";
        dimg = "docker images";
        dexc = "docker exec -it";
        drun = "docker run --rm -it";
        drma = "docker stop $(docker ps -aq) && docker rm -f $(docker ps -aq)";
        drmi = "di | grep none | awk '{print $3}' | sponge | xargs docker rmi";
      };
      initExtra = ''
        ulimit -n 10240
        eval "$(/opt/homebrew/bin/brew shellenv)"
        DISABLE_MAGIC_FUNCTIONS=true
        ZSH_AUTOSUGGEST_MANUAL_REBIND=1
        COMPLETION_WAITING_DOTS=true
        DISABLE_UNTRACKED_FILES_DIRTY=true
        export PATH="$PATH:/etc/profiles/per-user/wuz/bin:/usr/local/bin"
      '';
    };
  };
}
