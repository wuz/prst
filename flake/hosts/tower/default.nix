{
  conlin,
  nodes,
  ...
}:
{
  den = {
    hosts.x86_64-linux.tower.users."conlin.durbin" = { };

    aspects = {
      tower = {
        includes = with nodes; [
          auto-update
          nix
          sops
          packages
          shell
          wsl
        ];

        nixos = {
          system.stateVersion = "24.11";
          system.configurationRevision = null;

          wsl.enable = true;

          nixpkgs.config.allowUnfree = true;

          environment.pathsToLink = [
            "/share/bash-completion"
            "/share/zsh"
          ];
          programs.nix-index.enable = true;
        };
      };

      "conlin.durbin" = {
        includes = with conlin; [
          base
          git
          zsh
          starship
          direnv
          zoxide
          mcfly
          bat
          bin
          neovim
          node
          rust
          nixtools
          optout
        ];
      };
    };
  };
}
