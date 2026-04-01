{
  inputs,
  pkgs,
  config,
  ...
}:
let
  cobihax = inputs.jacobi.packages.${pkgs.stdenv.hostPlatform.system}.hax;
  shellAliases = {
    add = "git add -A";
    cm = "git cm";
    l = "eza -alFT --header -L 1";
    lg = "eza -alT -L 1 --header --git";
    ll = "eza -al";
    ls = "eza";
    lsd = "eza -lF | grep --color=never '^d'";
    cleanup = "find . -type f -name '*.DS_Store' -ls -delete";
    b64 = "base64 -w 0 | pbcopy";
    nixclean = "nix-collect-garbage -d";
    nixsearch = "nix-env -qaP | grep -i $1";

    proxyman = ''set -a && source "$HOME/.proxyman/proxyman_env_automatic_setup.sh" && set +a'';

    # git
    g = "git";
    gtc = "git tc";
  }
  // cobihax.docker_aliases
  // cobihax.kubernetes_aliases;
in
{
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases;
    dotDir = "${config.xdg.configHome}/zsh";
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "empresslabs/pnpm.plugin.zsh"; }
      ];
    };
    setOptions = [
      "autocd"
      "cdablevars"
      "histallowclobber"
      "histexpiredupsfirst"
      "histfcntllock"
      "histignorealldups"
      "histignoredups"
      "histignorespace"
      "histreduceblanks"
      "incappendhistory"
      "nomultios"
      "sharehistory"
    ];
    autosuggestion = {
      enable = true;
      strategy = [ "completion" ];
    };
    initContent = ''
      autoload -Uz compinit && compinit
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search
      bindkey "^[[B" down-line-or-beginning-search
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
      eval "$(${pkgs.just}/bin/just --completions zsh)"
      eval "$(${pkgs.pnpm}/bin/pnpm completion zsh)"
      eval "$(${pkgs.nodejs_22}/bin/node --completion-bash)"
      eval "$(wt config shell init zsh)"
    '';
  };
  # bash is disabled but kept for completeness
  programs.bash = {
    enable = false;
    enableCompletion = true;
    shellAliases = shellAliases;
  };
}
