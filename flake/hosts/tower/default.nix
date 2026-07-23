# tower — NixOS on WSL
{
  personal,
  work,
  nodes,
  ...
}:
{
  den = {
    hosts.x86_64-linux.tower.users."wuz" = { };

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

      # Personal user: CLI bundle only (headless host).
      # NOTE: den aspects merge by name — `wuz` also picks up the desktop
      # bundle defined for grimoire. Identity comes from there too.
      wuz.includes = [
        personal.base
        work.cli
      ];
    };
  };
}
