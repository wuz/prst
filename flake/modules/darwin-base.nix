# Shared base for all darwin workstations (spellbook, grimoire).
# Host files add only what genuinely differs: users, extra node aspects,
# and per-host overrides.
{ lib, nodes, ... }: {
  nodes.darwin-base.includes =
    (with nodes; [
      auto-update
      nix
      sops
      system
      packages
      homebrew
      shell
    ])
    ++ [
      ({ host, ... }: {
        darwin = {
          ids.gids.nixbld = 350;

          system.stateVersion = 5;
          system.configurationRevision = null;

          nixpkgs.config.allowUnfree = true;

          environment.pathsToLink = [ "/share/zsh" ];
          programs.nix-index.enable = true;

          # Single-user machines: primary user is the host's only user
          system.primaryUser = lib.head (lib.attrNames host.users);
          system.activationScripts.extraActivation.text = ''
            # Reload macOS settings without requiring logout/login
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
          '';

          security.pam.services.sudo_local = {
            enable = true;
            reattach = true;
            touchIdAuth = true;
            watchIdAuth = true;
          };
        };
      })
    ];
}
