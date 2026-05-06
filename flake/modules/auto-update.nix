{ ... }:
{
  nodes.auto-update = {
    # macOS: launchd agent that pulls and applies the config daily
    darwin = {
      launchd.user.agents."sh.prst.prst-update" = {
        serviceConfig = {
          Label = "sh.prst.prst-update";
          ProgramArguments = [
            "/bin/bash"
            "-c"
            ''
              set -euo pipefail
              FLAKE_DIR="$HOME/.config/darwin"
              LOG="$HOME/.local/share/prst/update.log"
              mkdir -p "$(dirname "$LOG")"

              echo "$(date): Starting update" >> "$LOG"

              # Pull latest config
              git -C "$FLAKE_DIR" pull --ff-only origin main >> "$LOG" 2>&1 || {
                echo "$(date): git pull failed — skipping rebuild" >> "$LOG"
                exit 0
              }

              # Apply — darwin-rebuild switch --flake .#spellbook
              /run/current-system/sw/bin/darwin-rebuild switch \
                --flake "$FLAKE_DIR#spellbook" >> "$LOG" 2>&1 && \
                echo "$(date): Update applied successfully" >> "$LOG" || \
                echo "$(date): Rebuild failed — previous generation still active" >> "$LOG"
            ''
          ];
          StartCalendarInterval = [
            {
              Hour = 9;
              Minute = 0;
            }
          ];
          StandardOutPath = "/tmp/prst-update.log";
          StandardErrorPath = "/tmp/prst-update.err";
          RunAtLoad = false;
        };
      };
    };

    # NixOS: systemd timer for WSL and future Linux hosts
    nixos = {
      systemd.services."prst-update" = {
        description = "Auto-update prst Nix configuration";
        serviceConfig = {
          Type = "oneshot";
          User = "conlin.durbin";
        };
        script = ''
          set -euo pipefail
          FLAKE_DIR="$HOME/.config/darwin"
          LOG="$HOME/.local/share/prst/update.log"
          mkdir -p "$(dirname "$LOG")"

          echo "$(date): Starting update" >> "$LOG"

          git -C "$FLAKE_DIR" pull --ff-only origin main >> "$LOG" 2>&1 || {
            echo "$(date): git pull failed — skipping" >> "$LOG"
            exit 0
          }

          nixos-rebuild switch --flake "$FLAKE_DIR#$(hostname -s)" >> "$LOG" 2>&1 && \
            echo "$(date): Update applied" >> "$LOG" || \
            echo "$(date): Rebuild failed — previous generation active" >> "$LOG"
        '';
      };

      systemd.timers."prst-update" = {
        description = "Daily prst Nix config update";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          RandomizedDelaySec = "30min";
          Persistent = true;
        };
      };
    };
  };
}
