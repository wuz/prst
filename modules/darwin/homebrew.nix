{
  lib,
  config,
  ...
}:
let
  cfg = config.homebrew;
  casks = builtins.filter (key: cfg.apps.${key}) (builtins.attrNames cfg.apps);
  enabled = (builtins.length casks) > 0;
  mkCaskOption =
    name: enabled:
    lib.mkOption {
      type = lib.types.bool;
      default = enabled;
      description = "Install ${name} cask via Homebrew.";
    };
in
{
  options.homebrew = {
    apps = {
      raycast = mkCaskOption "Raycast" false;
      slack = mkCaskOption "Slack" false;
      spotify = mkCaskOption "Spotify" false;
      whatsapp = mkCaskOption "WhatsApp" true;
      protonvpn = mkCaskOption "ProtonVPN" true;
      appcleaner = mkCaskOption "appcleaner" true;
      keybase = mkCaskOption "keybase" false;
      discord = mkCaskOption "Discord" false;
      elgato-control-center = mkCaskOption "Elgato Control Center" true;
      elgato-wave-link = mkCaskOption "Elgato Wave Link" true;
      floorp = mkCaskOption "Floorp" true;
      # "arc"
      # "wezterm"
      # "setapp"
      # "affinity-designer"
      # "affinity-photo"
      # "affinity-publisher"
      # "betterdisplay"
      # "figma"
      # "obsidian"
      # "muzzle"
      # "karabiner-elements"
      # "notion-calendar"
      # "obsidian"
      # "transmission"
      # "little-snitch"
      # "micro-snitch"
      # "docker"
      # "discord"
    };
  };
  config = {
    homebrew = {
      enable = enabled;
      casks = casks;
      caskArgs.no_quarantine = true;
    };
  };
}
