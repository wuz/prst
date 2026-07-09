{ inputs, ... }:
{
  work.email = {
    homeManager =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        matchaConfigFile = pkgs.writeText "matcha-config.json" (
          builtins.toJSON {
            accounts = [
              {
                id = "personal";
                name = "Personal";
                email = "conlind@proton.me";
                service_provider = "custom";
                fetch_email = "conlind@proton.me";
                catch_all = true;
                imap_server = "127.0.0.1";
                imap_port = 1143;
                smtp_server = "127.0.0.1";
                smtp_port = 1025;
                insecure = true;
              }
              # {
              #   id = "work";
              #   name = "Work";
              #   email = "conlin.durbin@whatnot.com";
              #   service_provider = "gmail";
              #   fetch_email = "conlin.durbin@whatnot.com";
              #   auth_method = "oauth2";
              # }
            ];
            theme = "Matcha";
            enable_split_pane = true;
            enable_threaded = true;
            date_format = "MM/DD/YYYY hh:MM AM";
            language = "en";
          }
        );
      in
      {
        home.packages = [
          # Override doCheck=false — matcha's image-rendering test panics in the
          # Nix sandbox (no display available) and would block every rebuild.
          # Override go → pkgs.go to avoid toolchain download (matcha's go.mod
          # specifies a toolchain version newer than what nix ships; GOTOOLCHAIN=local
          # tells the build to use whatever Go is in PATH instead of fetching).
          (inputs.matcha.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
            doCheck = false;
            # matcha's go.mod requires go 1.26.4 but nixpkgs ships 1.26.3.
            # Patch go.mod to match what's available; GOTOOLCHAIN=local prevents
            # the build from trying to download a newer toolchain at build time.
            GOTOOLCHAIN = "local";
            postPatch = (old.postPatch or "") + ''
              sed -i 's/^go 1\.26\.4/go 1.26.3/' go.mod
            '';
          }))
          pkgs.protonmail-bridge
        ];

        # Proton Mail Bridge — background daemon exposing local IMAP/SMTP.
        # First-time setup: run `protonmail-bridge --cli`, use the `login`
        # command to authenticate, then note the bridge-generated password
        # shown by `info 0`. Encrypt it into secrets/hosts/common.yaml as
        # `protonmail-bridge-password`.
        launchd.agents.protonmail-bridge = {
          enable = true;
          config = {
            Label = "com.protonmail.bridge";
            ProgramArguments = [
              "${pkgs.protonmail-bridge}/bin/protonmail-bridge"
              "--noninteractive"
            ];
            RunAtLoad = true;
            KeepAlive = true;
            StandardOutPath = "/tmp/protonmail-bridge.log";
            StandardErrorPath = "/tmp/protonmail-bridge-error.log";
          };
        };

        # Write initial matcha config. Uses copy-if-absent so matcha can write
        # back to config.json at runtime (settings toggles, theme changes, etc.)
        # without hitting a read-only Nix store symlink.
        # To force-reset: rm ~/.config/matcha/config.json && darwin-rebuild switch
        home.activation.setupMatchaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          configDir="${config.xdg.configHome}/matcha"
          configFile="$configDir/config.json"
          mkdir -p "$configDir"
          if [ ! -f "$configFile" ]; then
            cp ${matchaConfigFile} "$configFile"
            chmod 644 "$configFile"
          fi
        '';

        # Write Proton bridge password to macOS Keychain so matcha can read it
        # via go-keyring. The secret is decrypted by sops-nix at activation time.
        # Work account uses OAuth2 (browser-based, one-time) — no secret needed.
        home.activation.setupEmailCredentials = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          secretFile="/run/secrets/protonmail-bridge-password"
          if [ -f "$secretFile" ]; then
            pw=$(cat "$secretFile")
            /usr/bin/security delete-generic-password \
              -s "matcha-email-client" -a "c@wuz.sh" 2>/dev/null || true
            /usr/bin/security add-generic-password \
              -s "matcha-email-client" -a "c@wuz.sh" -w "$pw"
          fi
        '';
      };
  };
}
