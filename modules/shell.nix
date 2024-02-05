{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  shellAliases = {
    add = "git add -A";
    cm = "git cm";
    l = "exa -alFT --header -L 1";
    lg = "exa -alT -L 1 --header --git";
    ll = "exa -al";
    ls = "exa";
    lsd = "exa -lF | grep --color=never '^d'";
    cleanup = "find . -type f -name '*.DS_Store' -ls -delete";
    b64 = "base64 -w 0 | pbcopy";
    nixclean = "nix-collect-garbage -d";
    nixsearch = "nix-env -qaP | grep -i $1";

    # docker
    d = "docker";
    dall = "docker ps -a";
    dimg = "docker images";
    dexc = "docker exec -it";
    drun = "docker run --rm -it";
    drma = "docker stop $(docker ps -aq) && docker rm -f $(docker ps -aq)";
    drmi = "di | grep none | awk '{print $3}' | sponge | xargs docker rmi";
  };
in {
  home-manager.users."wuz" = {
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
	battery = { disabled = true; };
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
    };
    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = shellAliases;
      bashrcExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
