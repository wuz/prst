{ ... }:
{
  work.zsh = {
    homeManager =
      { pkgs, config, ... }:
      {
        programs.zsh = {
          enable = true;
          dotDir = "${config.xdg.configHome}/zsh";
          shellAliases = {
            # git shortcuts
            g = "git";
            add = "git add -A";
            cm = "git cm";
            gtc = "git tc";

            # ls replacements
            l = "eza -alFT --header -L 1";
            lg = "eza -alT -L 1 --header --git";
            ll = "eza -al";
            ls = "eza";
            lsd = "eza -lF | grep --color=never '^d'";

            # utilities
            cleanup = "find . -type f -name '*.DS_Store' -ls -delete";
            b64 = "base64 -w 0 | pbcopy";
            nixclean = "nix-collect-garbage -d";
            nixsearch = "nix-env -qaP | grep -i $1";

            # docker
            d = "docker";
            dc = "docker compose";
            dps = "docker ps";
            dim = "docker images";
            dex = "docker exec -it";
            dlog = "docker logs -f";

            # kubernetes
            k = "kubectl";
            kgp = "kubectl get pods";
            kgs = "kubectl get services";
            kgd = "kubectl get deployments";
            kaf = "kubectl apply -f";
            kdf = "kubectl delete -f";
            kex = "kubectl exec -it";
            klo = "kubectl logs -f";
            kns = "kubectl config set-context --current --namespace";
          };
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
            path=($HOME/.local/bin $path)
            autoload -Uz compinit && compinit
            autoload -U up-line-or-beginning-search
            autoload -U down-line-or-beginning-search
            zle -N up-line-or-beginning-search
            zle -N down-line-or-beginning-search
            bindkey "^[[A" up-line-or-beginning-search
            bindkey "^[[B" down-line-or-beginning-search

            # Homebrew (darwin only — gracefully skipped on Linux)
            if [[ -f /opt/homebrew/bin/brew ]]; then
              eval "$(/opt/homebrew/bin/brew shellenv zsh)"
            fi

            eval "$(${pkgs.just}/bin/just --completions zsh)"

            if command -v wt >/dev/null 2>&1; then
              eval "$(wt config shell init zsh)"
            fi
            if command -v bonsai >/dev/null 2>&1; then
              eval "$(bonsai shell-setup)"
            fi
          '';
        };
      };
  };
}
