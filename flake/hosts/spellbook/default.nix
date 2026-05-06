{ prst, nodes, ... }:
{
  den = {
    hosts.aarch64-darwin.spellbook.users."conlin.durbin" = { };

    aspects = {
      spellbook = {
        includes = with nodes; [
          auto-update
          nix
          sops
          system
          packages
          homebrew
          shell
          duckypad
        ];

        darwin = {
          ids.gids.nixbld = 350;

          system.stateVersion = 5;
          system.configurationRevision = null;

          nixpkgs.config = {
            allowUnfree = true;
            permittedInsecurePackages = [ "python3.13-ecdsa-0.19.1" ];
          };

          environment.pathsToLink = [ "/share/zsh" ];
          programs.nix-index.enable = true;

          system.primaryUser = "conlin.durbin";
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
      };

      # User aspect — den auto-creates den.aspects."conlin.durbin" for the user.
      # We write here to populate it with user programs via the prst namespace.
      "conlin.durbin" = {
        homeManager = { ... }: {
          programs.git.settings.user.email = "conlin.durbin@whatnot.com";
          programs.tiny.enable = true;
          programs.xplr.enable = true;
        };

        includes = with prst; [
          base
          git
          zsh
          starship
          direnv
          zoxide
          mcfly
          bat
          bin
          tui
          neovim
          wezterm
          ghostty
          node
          rust
          nixtools
          lua
          ruby
          browser
          email
          optout
          ssh
          zed
          jj
        ];
      };
    };
  };
}
