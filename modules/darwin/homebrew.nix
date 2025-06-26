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
      zen = mkCaskOption "Zen" false;
      slack = mkCaskOption "Slack" false;
      spotify = mkCaskOption "Spotify" false;
      whatsapp = mkCaskOption "WhatsApp" true;
      protonvpn = mkCaskOption "ProtonVPN" true;
      appcleaner = mkCaskOption "appcleaner" true;
      keybase = mkCaskOption "keybase" false;
      discord = mkCaskOption "Discord" false;
      elgato-control-center = mkCaskOption "Elgato Control Center" true;
      elgato-stream-deck = mkCaskOption "Elgato Stream Deck" true;
      elgato-wave-link = mkCaskOption "Elgato Wave Link" true;
      # Ghostty on nix seems broken for darwin right now
      ghostty = mkCaskOption "ghostty" false;
      figma = mkCaskOption "Gigma" false;
      obsidian = mkCaskOption "obsidian" false;
      muzzle = mkCaskOption "muzzle" false;

      little-snitch = mkCaskOption "little-snitch" false;
      micro-snitch = mkCaskOption "micro-snitch" false;

      betterdisplay = mkCaskOption "betterdisplay" false;
      affinity-designer = mkCaskOption "Affinity Designer" false;
      affinity-photo = mkCaskOption "Affinity Photo" false;
      affinity-publisher = mkCaskOption "Affinity Publisher" false;

      karabiner-elements = mkCaskOption "Karabiner Elements" false;
      transmission = mkCaskOption "transmission" false;

      graphiql = mkCaskOption "GraphiQL" false;

      notion = mkCaskOption "Notion" false;
      notion-calendar = mkCaskOption "Notion Calendar" false;
      notion-mail = mkCaskOption "Notion Mail" false;

      brilliant = mkCaskOption "Brilliant" false;
      moves = mkCaskOption "Moves" false;
      peninsula = mkCaskOption "Peninsula" false;
      fruit-screensaver = mkCaskOption "Fruit" false;
      tiny-shield = mkCaskOption "Tiny Shield" false;
      music-presence = mkCaskOption "Discord Music Presence" false;

      # ca-certificates
      # docker
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
