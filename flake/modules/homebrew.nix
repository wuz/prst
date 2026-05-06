{ lib, ... }:
{
  nodes.homebrew =
    let
      mkCaskOption =
        name: enabled:
        lib.mkOption {
          type = lib.types.bool;
          default = enabled;
          description = "Install ${name} cask via Homebrew.";
        };
      mkBrewOption =
        name: enabled:
        lib.mkOption {
          type = lib.types.bool;
          default = enabled;
          description = "Install ${name} brew via Homebrew.";
        };
    in
    {
      darwin =
        { config, ... }:
        let
          cfg = config.homebrew;
          casks = builtins.filter (key: cfg.apps.${key}) (builtins.attrNames cfg.apps);
          brews = builtins.filter (key: cfg.tools.${key}) (builtins.attrNames cfg.tools);
        in
        {
          options.homebrew = {
            tools = {
              bandcamp-dl = mkBrewOption "bandcamp-dl" true;
              ghalint = mkBrewOption "ghalint" true;
              jiratui = mkBrewOption "jiratui" true;
              docker = mkBrewOption "docker" true;
              mole = mkBrewOption "mole" true;
              worktrunk = mkBrewOption "worktrunk" true;
              weave = mkBrewOption "weave" true;
              gtab = mkBrewOption "gtab" true;
            };
            apps = {
              # productivity
              raycast = mkCaskOption "Raycast" true;
              anki = mkCaskOption "Anki" true;
              notchnook = mkCaskOption "NotchNook" true;
              protonvpn = mkCaskOption "ProtonVPN" true;
              hammerspoon = mkCaskOption "Hammerspoon" false;
              finetune = mkCaskOption "FineTune" true;
              lm-studio = mkCaskOption "LMStudio" false;
              petrichor = mkCaskOption "Petrichor" true;
              meta = mkCaskOption "Meta" true;

              obsidian = mkCaskOption "Obsidian" false;
              notion = mkCaskOption "Notion" false;
              notion-calendar = mkCaskOption "Notion Calendar" false;
              notion-mail = mkCaskOption "Notion Mail" false;
              moves = mkCaskOption "Moves" false;
              sky = mkCaskOption "Sky.app" false;

              # utility
              appcleaner = mkCaskOption "AppCleaner" true;
              elgato-control-center = mkCaskOption "Elgato Control Center" true;
              elgato-stream-deck = mkCaskOption "Elgato Stream Deck" true;
              elgato-wave-link = mkCaskOption "Elgato Wave Link" true;
              lolgato = mkCaskOption "Lolgato" true;
              appvolume = mkCaskOption "AppVolume" false;
              fruit-screensaver = mkCaskOption "Fruit" true;
              little-snitch = mkCaskOption "Little Snitch" true;
              micro-snitch = mkCaskOption "Micro Snitch" true;

              crystalfetch = mkCaskOption "CrystalFetch" false;
              keybase = mkCaskOption "Keybase" false;
              betterdisplay = mkCaskOption "BetterDisplay" false;
              muzzle = mkCaskOption "Muzzle" false;
              karabiner-elements = mkCaskOption "Karabiner Elements" false;
              peninsula = mkCaskOption "Peninsula" false;
              tiny-shield = mkCaskOption "Tiny Shield" false;
              music-presence = mkCaskOption "Discord Music Presence" false;
              rockboxutility = mkCaskOption "Rockbox" false;
              utm = mkCaskOption "UTM" false;

              # development
              ghostty = mkCaskOption "Ghostty" false; # Ghostty on nix seems broken for darwin right now
              graphiql = mkCaskOption "GraphiQL" false;
              docker-desktop = mkCaskOption "Docker Desktop" false;

              # design
              figma = mkCaskOption "Figma" false;
              brilliant = mkCaskOption "Brilliant" false;
              inkscape = mkCaskOption "Inkscape" false;
              inkstitch = mkCaskOption "Inkstitch" false;

              # chat
              slack = mkCaskOption "Slack" false;
              whatsapp = mkCaskOption "WhatsApp" false;
              discord = mkCaskOption "Discord" false;

              # browsing
              zen = mkCaskOption "Zen" false;
              "zen@twilight" = mkCaskOption "Zen Twilight" false;
              orion = mkCaskOption "Orion" true;
              raindropio = mkCaskOption "Raindrop.io" false;
              spotify = mkCaskOption "Spotify" false;
              qobuz = mkCaskOption "Qobuz" true;
              deezer = mkCaskOption "Deezer" false;
              transmission = mkCaskOption "Transmission" false;
            };
          };

          config.homebrew = {
            enable = (builtins.length casks) > 0 || (builtins.length brews) > 0;
            casks = casks;
            brews = brews;
            enableZshIntegration = true;
            enableBashIntegration = true;
            taps = [
              {
                name = "chmouel/lazyworktree";
                clone_target = "https://github.com/chmouel/lazyworktree";
              }
              {
                name = "Franvy/gtab";
                clone_target = "https://github.com/Franvy/gtab";
              }
            ];
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
    };
}
