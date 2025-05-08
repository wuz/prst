{ inputs, pkgs, ... }:
let
  cobihax = inputs.jacobi.packages.${pkgs.system}.hax;
  shellAliases =
    {
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
      # d = "docker";
      # dall = "docker ps -a";
      # dimg = "docker images";
      # dexc = "docker exec -it";
      # drun = "docker run --rm -it";
      # drma = "docker stop $(docker ps -aq) && docker rm -f $(docker ps -aq)";
      # drmi = "di | grep none | awk '{print $3}' | sponge | xargs docker rmi";
      proxyman = ''set -a && source "/Users/conlin.durbin/.proxyman/proxyman_env_automatic_setup.sh" && set +a'';

      # git
      g = "git";
      gtc = "git tc";
    }
    // cobihax.docker_aliases
    // cobihax.kubernetes_aliases;
in
{
  programs.starship = {
    enable = true;
    settings = (builtins.fromTOML (builtins.readFile ../../../configs/starship/starship.toml));
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      source <(${pkgs.just}/bin/just --completions zsh)
    '';
    # source <(${pkgs.jujutsu}/bin/jj util completion zsh)
  };
  programs.bash = {
    enable = false;
    enableCompletion = true;
    shellAliases = shellAliases;
    bashrcExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      source "$(blesh-share)"/ble.sh --attach=none
      [[ ! $\{BLE_VERSION-\} ]] || ble-attach
    '';
  };
}
