{ config, pkgs, lib, ... }:
with pkgs.hax; {
  programs.bash = {
    enable = true;
    inherit (config.home) sessionVariables;
    historyFileSize = -1;
    historySize = -1;
    shellAliases = {
      ".s" = "source ~/.bash_profile";
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
    };
    initExtra = ''
      # Autocorrect typos in path names when using `cd`
      source ~/.nix-profile/etc/profile.d/nix.sh
      shopt -s cdspell


      GPG_TTY=$(tty)
      export GPG_TTY

      source ~/.nix-profile/etc/profile.d/bash_completion.sh
      source ~/.nix-profile/share/bash-completion/completions/git
      source ~/.nix-profile/share/bash-completion/completions/ssh
      # complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

      eval "$(zoxide init bash)"


      # export KEYS_AUTH=`keys auth -token`
      export PATH="$PATH:~/.bin"
      export PATH="$PATH:Users/wuz/.local/share/gem/ruby/2.7.0/gems"

      export PS1="\$(familiar)"

      function brewurl {
        echo "Looking for $1"
        curl "https://formulae.brew.sh/api/cask/$1.json" | jq
        echo "sha256"
        nix-prefetch-url "https://formulae.brew.sh/api/cask/$1.json"
      }
    '';
  };
}
