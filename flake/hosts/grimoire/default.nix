{ personal, work, nodes, ... }:
{
  den = {
    hosts.aarch64-darwin.grimoire.users."wuz" = { };

    aspects = {
      grimoire = {
        includes = with nodes; [
          auto-update
          nix
          sops
          system
          packages
          homebrew
          shell
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

          system.primaryUser = "wuz";
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

      # Personal user aspect for wuz on grimoire
      wuz = {
        homeManager = { ... }: {
          programs.git.signing = {
            key = "CAA69BFC5EF24C40";
            signByDefault = true;
            format = "openpgp";
          };
          programs.git.settings.user = {
            name = "Conlin Durbin";
            email = "c@wuz.sh";
          };
        };

        includes =
          # personal.base sets username=wuz, homeDirectory=/Users/wuz
          [ personal.base ]
          # Reuse work.* program aspects — same tooling, personal identity set above
          ++ (with work; [
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
          ]);
      };
    };
  };
}
