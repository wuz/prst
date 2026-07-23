{ ... }: {
  work.zsh = {
    homeManager =
      {
        pkgs,
        config,
        lib,
        ...
      }:
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
            nixsearch = "nix search nixpkgs";

            # docker
            d = "docker";
            dc = "docker compose";
            dps = "docker ps";
            dim = "docker images";
            dex = "docker exec -it";
            dlog = "docker logs -f";

            oc-investigate = "OPENCODE_CONFIG=~/.config/opencode/modes/investigate.jsonc opencode";
            oc-project = "OPENCODE_CONFIG=~/.config/opencode/modes/project.jsonc opencode";

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
          initContent = lib.mkMerge [
            # mkOrder 550 runs before compinit (which fires at 560)
            (lib.mkOrder 550 ''
              path=($HOME/.local/bin $path)

              # Homebrew must be sourced before compinit to populate fpath with site-functions
              if [[ -f /opt/homebrew/bin/brew ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv zsh)"
              fi
            '')

            # Default order (1000) — post-compinit content
            ''
              # zmx: set tab title to session name when attached
              if [[ -n "$ZMX_SESSION" ]]; then
                printf '\e]2;%s\a' "$ZMX_SESSION"
                # Also update on every prompt so title stays correct
                precmd_zmx_title() { printf '\e]2;%s\a' "$ZMX_SESSION"; }
                autoload -Uz add-zsh-hook
                add-zsh-hook precmd precmd_zmx_title
              fi

              # zmx session picker: `zs` to fzf-select and attach
              function zs() {
                local name
                if [[ $# -gt 0 ]]; then
                  name="$1"
                elif command -v fzf &>/dev/null && command -v zmx &>/dev/null; then
                  name=$(zmx list --short 2>/dev/null | fzf --prompt="session> " --height=10) || return 0
                else
                  zmx list 2>/dev/null
                  return 0
                fi
                [[ -n "$name" ]] && zmx attach "$name"
              }
              autoload -U up-line-or-beginning-search
              autoload -U down-line-or-beginning-search
              zle -N up-line-or-beginning-search
              zle -N down-line-or-beginning-search
              bindkey "^[[A" up-line-or-beginning-search
              bindkey "^[[B" down-line-or-beginning-search

              eval "$(${pkgs.just}/bin/just --completions zsh)"

              if command -v wt >/dev/null 2>&1; then
                eval "$(wt config shell init zsh)"
              fi
              if command -v bonsai >/dev/null 2>&1; then
                eval "$(bonsai shell-setup)"
              fi
            ''
          ];
        };
      };
  };
}
