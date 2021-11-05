{ config, pkgs, lib, ... }:
with pkgs.hax; {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    #enableVteIntegration = true;
    #inherit (config.home) sessionVariables;
    #prezto = {
    #  enable = true;
    #};
    zplug = {
      enable = true;
      # plugins = [{
      #   name = "g-plane/zsh-yarn-autocompletions";
      #   tags = [ "hook-build:./zplug.zsh" ];
      # }];
    };
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
      . /Users/wuz/.nix-profile/etc/profile.d/nix.sh
      export PATH="$PATH:/run/current-system/sw/bin:/usr/local/bin"
      export NIX_PATH="$NIX_PATH:darwin-rebuild=$HOME/.config/nixpkgs/darwin.nix"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      eval "$(mcfly init zsh)"
    '';
  };
}
