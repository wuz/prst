{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs) fetchFromGithub;
in {
  home-manager.users.wuz = {
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
        strip = ''
          sed -E 's#^\s+|\s+$##g'
        '';

        # nix
        nix_hash = "nix-prefetch-url";
        nix_hash_git = "nix-prefetch-git";

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
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
        eval "$(/opt/homebrew/bin/brew shellenv)"
        source /Users/wuz/.iterm2_shell_integration.zsh
        DISABLE_MAGIC_FUNCTIONS=true
        ZSH_AUTOSUGGEST_MANUAL_REBIND=1
        COMPLETION_WAITING_DOTS=true
        DISABLE_UNTRACKED_FILES_DIRTY=true
        export PATH="$PATH:/etc/profiles/per-user/wuz/bin:/usr/local/bin"
      '';
    };
  };
}
