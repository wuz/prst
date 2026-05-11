{ work, nodes, ... }:
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

      # Work user aspect for conlin.durbin on spellbook
      "conlin.durbin" = {
        # Work-specific overrides layered on top of shared work programs
        homeManager = { ... }: {
          programs.git.signing = {
            key = "CAA69BFC5EF24C40";
            signByDefault = true;
            format = "openpgp";
          };
          programs.git.settings.user = {
            name = "Conlin Durbin";
            email = "conlin.durbin@whatnot.com";
          };
          programs.tiny.enable = true;
          programs.xplr.enable = true;
        };

        includes = with work; [
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
