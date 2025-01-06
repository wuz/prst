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
      floorp = mkCaskOption "Floorp" false;
      # Ghostty on nix seems broken for darwin right now
      ghostty = mkCaskOption "ghostty" false;
      # "arc"
      # "wezterm"
      # "setapp"

      betterdisplay = mkCaskOption "betterdisplay" false;
      affinity-designer = mkCaskOption "affinity-designer" false;
      affinity-photo = mkCaskOption "affinity-photo" false;
      affinity-publisher = mkCaskOption "affinity-publisher" false;

      karabiner-elements = mkCaskOption "karabiner-elements" false;
      transmission = mkCaskOption "transmission" false;
      notion-calendar = mkCaskOption "notion-calendar" false;

      # "figma"
      # "obsidian"
      # "muzzle"
      # "obsidian"
      # "little-snitch"
      # "micro-snitch"
      # "docker"
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
