{
  lib,
  config,
  ...
}:
let
  cfg = config.homebrew;
  casks = builtins.filter (key: cfg.apps.${key}) (builtins.attrNames cfg.apps);
  brews = builtins.filter (key: cfg.tools.${key}) (builtins.attrNames cfg.tools);
  enabled = (builtins.length casks) > 0;
  mkBrewOption =
    name: enabled:
    lib.mkOption {
      type = lib.types.bool;
      default = enabled;
      description = "Install ${name} brew via Homebrew.";
    };
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
    tools = {
      bandcamp-dl = mkBrewOption "bandcamp-dl" true;
      ghalint = mkBrewOption "ghalint" true;
      jiratui = mkBrewOption "jiratui" true;
      lazycontainer = mkBrewOption "lazycontainer" true;
      ca-certificates = mkBrewOption "ca-certificates" true;
      docker = mkBrewOption "docker" true;
    };
    apps = {
      # productivity
      raycast = mkCaskOption "Raycast" true;
      notchnook = mkCaskOption "NotchNook" true;
      protonvpn = mkCaskOption "ProtonVPN" true;

      obsidian = mkCaskOption "obsidian" false;
      notion = mkCaskOption "Notion" false;
      notion-calendar = mkCaskOption "Notion Calendar" false;
      notion-mail = mkCaskOption "Notion Mail" false;
      notion-enhanced = mkCaskOption "Notion Enhanced" false;
      moves = mkCaskOption "Moves" false;

      # utility
      appcleaner = mkCaskOption "appcleaner" true;
      elgato-control-center = mkCaskOption "Elgato Control Center" true;
      elgato-stream-deck = mkCaskOption "Elgato Stream Deck" true;
      elgato-wave-link = mkCaskOption "Elgato Wave Link" true;
      fruit-screensaver = mkCaskOption "Fruit" true;
      little-snitch = mkCaskOption "little-snitch" true;
      micro-snitch = mkCaskOption "micro-snitch" true;
      jordanbaird-ice = mkCaskOption "Ice" true;

      container = mkCaskOption "container" false;
      crystalfetch = mkCaskOption "crystfetch" false;
      keybase = mkCaskOption "keybase" false;
      betterdisplay = mkCaskOption "betterdisplay" false;
      muzzle = mkCaskOption "muzzle" false;
      karabiner-elements = mkCaskOption "Karabiner Elements" false;
      peninsula = mkCaskOption "Peninsula" false;
      tiny-shield = mkCaskOption "Tiny Shield" false;
      music-presence = mkCaskOption "Discord Music Presence" false;
      rockboxutility = mkCaskOption "Rockbox" false;
      utm = mkCaskOption "UTM" false;

      # development
      ghostty = mkCaskOption "ghostty" false; # Ghostty on nix seems broken for darwin right now
      graphiql = mkCaskOption "GraphiQL" false;
      docker-desktop = mkCaskOption "Docker Desktop" false;

      # design
      affinity-designer = mkCaskOption "Affinity Designer" false;
      affinity-photo = mkCaskOption "Affinity Photo" false;
      affinity-publisher = mkCaskOption "Affinity Publisher" false;
      figma = mkCaskOption "Gigma" false;
      brilliant = mkCaskOption "Brilliant" false;
      inkscape = mkCaskOption "Inkscape" false;
      inkstitch = mkCaskOption "Inkstitch" false;

      # chat
      slack = mkCaskOption "Slack" false;
      whatsapp = mkCaskOption "WhatsApp" false;
      discord = mkCaskOption "Discord" false;

      # browsing
      zen = mkCaskOption "Zen" true;
      "zen@twilight" = mkCaskOption "Zen Twilight" false;

      orion = mkCaskOption "Orion" false;
      raindropio = mkCaskOption "Raindrop.io" false;
      spotify = mkCaskOption "Spotify" false;
      deezer = mkCaskOption "Deezer" false;
      transmission = mkCaskOption "Transmission" false;
      lastfm = mkCaskOption "LastFM" false;

    };
  };
  config = {
    homebrew = {
      enable = enabled;
      casks = casks;
      brews = brews;
      onActivation = {
        upgrade = true;
        autoUpdate = true;
        cleanup = "zap";
      };
      caskArgs = {
        no_quarantine = true;
        appdir = "~/Applications";
      };
    };
  };
}
