{ inputs, ... }: {
  work.browser = {
    homeManager =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        extensions =
          with pkgs.nur.repos.rycee.firefox-addons;
          [
            react-devtools
            adnauseam
            stylus
            proton-pass
            sponsorblock
            privacy-possum
            violentmonkey
            raindropio
            don-t-fuck-with-paste
            enhanced-github
            refined-github
            rsspreview
            reddit-enhancement-suite
            libredirect
            are-na
            bitwarden
          ]
          ++ (with pkgs.firefox-addons; [
            almost-dark-proton
            libraryextension
            container-script
            google-lighthouse
            open-graph-previewer
            openlink-structured-data-sniff
            remove-paywall
            request-blocker-we
            # winger
          ]);
      in
      {
        imports = [ inputs.zen-browser.homeModules.twilight ];

        # Set MOZ_LEGACY_PROFILES globally so Zen launched from Dock/Spotlight
        # ignores installs.ini and reads profiles.ini directly, preventing
        # "profile missing" errors after every Nix rebuild.
        launchd.agents.zen-legacy-profiles = {
          enable = true;
          config = {
            ProgramArguments = [
              "/bin/launchctl"
              "setenv"
              "MOZ_LEGACY_PROFILES"
              "1"
            ];
            RunAtLoad = true;
          };
        };

        home.activation.fixZenProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          # Patch installs.ini to redirect all install hashes to Profiles/wuz
          installs="${config.home.homeDirectory}/Library/Application Support/Zen/installs.ini"
          if [ -f "$installs" ]; then
            # Redirect non-wuz Default= entries to wuz, remove Locked= lines
            ${pkgs.gnused}/bin/sed -i \
              -e 's|^Default=Profiles/[^w][^u][^z].*|Default=Profiles/wuz|g' \
              -e '/^Locked=/d' \
              "$installs"
          fi
          # Clean up auto-created empty profiles from previous rebuilds
          find "${config.home.homeDirectory}/Library/Application Support/Zen/Profiles" \
            -maxdepth 1 -name "*.Default (twilight)" -type d \
            -exec rm -rf {} + 2>/dev/null || true
        '';

        # Firefox/Zen persists every pref it has ever seen into the profile's
        # prefs.js, and prefs.js is read AFTER user.js on startup, so a stale
        # value there silently wins over whatever we declare in `settings`
        # above. Strip any key we currently (or ever previously) managed out
        # of prefs.js on every rebuild so user.js's value always takes effect
        # on next launch — whether we changed it or removed it entirely.
        home.activation.syncZenManagedPrefs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          profileDir="${config.home.homeDirectory}/Library/Application Support/Zen/Profiles/wuz"
          userJs="$profileDir/user.js"
          prefsJs="$profileDir/prefs.js"
          stateFile="$profileDir/.hm-managed-prefs"

          if [ -e "$profileDir/.parentlock" ]; then
            echo "zen-browser: profile locked (Zen is running) — quit Zen and relaunch to pick up changed settings" >&2
          elif [ -f "$userJs" ] && [ -f "$prefsJs" ]; then
            currentKeys=$(${pkgs.gnugrep}/bin/grep -oE 'user_pref\("[^"]+"' "$userJs" | ${pkgs.coreutils}/bin/cut -d'"' -f2 | ${pkgs.coreutils}/bin/sort -u)
            if [ -f "$stateFile" ]; then
              stripKeys=$(printf '%s\n%s\n' "$currentKeys" "$(cat "$stateFile")" | ${pkgs.coreutils}/bin/sort -u)
            else
              stripKeys="$currentKeys"
            fi

            printf '%s\n' "$stripKeys" > "$profileDir/.strip-keys.tmp"
            ${pkgs.gawk}/bin/awk '
              NR==FNR { if (length($0)) strip[$0]=1; next }
              {
                line=$0
                if (match(line, /^user_pref\("[^"]+"/)) {
                  key=substr(line, 12, RLENGTH-12)
                  if (key in strip) next
                }
                print line
              }
            ' "$profileDir/.strip-keys.tmp" "$prefsJs" > "$prefsJs.tmp" && mv "$prefsJs.tmp" "$prefsJs"

            printf '%s\n' "$currentKeys" > "$stateFile"
            rm -f "$profileDir/.strip-keys.tmp"
          fi
        '';

        programs.zen-browser = {
          darwinDefaultsId = "app.zen-browser.zen";
          enable = true;
          policies = {
            AppAutoUpdate = false;
            DisableAppUpdate = true;
            ManualAppUpdateOnly = true;
            BackgroundAppUpdate = false;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxScreenshots = true;
            DontCheckDefaultBrowser = true;
            HardwareAcceleration = true;
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;
            OfferToSaveLogins = false;
            LegacyProfiles = true;
            NoDefaultBookmarks = true;
            UserMessaging = {
              ExtensionRecommendations = false;
              FeatureRecommendations = false;
              MoreFromMozilla = false;
              SkipOnboarding = true;
              UrlbarInterventions = false;
              WhatsNew = false;
              Locked = true;
            };
            ExtensionUpdate = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = false;
              Cryptomining = true;
              Fingerprinting = true;
              EmailTracking = true;
              Category = "standard";
              Exceptions = [
                "https://raindrop.io"
                "https://app.raindrop.io"
                "https://api.raindrop.io"
                "https://bsky.social"
              ];
            };
            Cookies = {
              Allow = [
                "https://raindrop.io"
                "https://app.raindrop.io"
                "https://api.raindrop.io"
                "https://bsky.social"
              ];
            };
            FirefoxHome = {
              Search = true;
              TopSites = false;
              SponsoredTopSites = false;
              Highlights = false;
              Pocket = false;
              SponsoredPocket = false;
              Snippets = false;
              Locked = true;
            };
            FirefoxSuggest = {
              WebSuggestions = false;
              SponsoredSuggestions = false;
              ImproveSuggest = false;
              Locked = true;
            };
            Preferences = {
              "browser.contentblocking.category" = {
                Value = "strict";
                Status = "locked";
              };
              "extensions.pocket.enabled" = {
                Value = false;
                Status = "locked";
              };
              "browser.formfill.enable" = {
                Value = false;
                Status = "locked";
              };
              "browser.topsites.contile.enabled" = {
                Value = false;
                Status = "locked";
              };
              "browser.newtabpage.activity-stream.feeds.topsites" = {
                Value = false;
                Status = "locked";
              };
            };
            "3rdparty".Extensions = {
              "adnauseam@rednoise.org".adminSettings = {
                selectedFilterLists = [
                  "adguard-generic"
                  "adguard-mobile-app-banners"
                  "adguard-social"
                  "adguard-spyware-url"
                  "adguard-widgets"
                  "easylist"
                  "easyprivacy"
                  "fanboy-cookiemonster"
                  "fanboy-social"
                  "plowe-0"
                  "ublock-abuse"
                  "ublock-badware"
                  "ublock-filters"
                  "ublock-privacy"
                  "ublock-quick-fixes"
                  "ublock-unbreak"
                  "urlhaus-1"
                  "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                ];
              };
            };
          };
          profiles.wuz = {
            isDefault = true;
            extensions.packages = extensions;
            containersForce = true;
            containers = {
              citadel = {
                color = "toolbar";
                icon = "fence";
                id = 3;
              };
              work = {
                color = "yellow";
                icon = "briefcase";
                id = 2;
              };
              personal = {
                color = "blue";
                icon = "circle";
                id = 1;
              };
              reading = {
                color = "purple";
                icon = "chill";
                id = 4;
              };
            };
            spacesForce = true;
            spaces =
              let
                containers = config.programs.zen-browser.profiles."wuz".containers;
              in
              {
                "Home" = {
                  id = "c6de089c-410d-4206-961d-ab11f988d40a";
                  icon = "🏠";
                  container = containers."personal".id;
                  position = 1000;
                };
                "Work" = {
                  id = "cdd10fab-4fc5-494b-9041-325e5759195b";
                  icon = "💼";
                  container = containers."work".id;
                  position = 2000;
                };
                "Infinite Citadel" = {
                  id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
                  icon = "🏰";
                  container = containers."citadel".id;
                  position = 3000;
                };
              };
            search = {
              force = true;
              default = "kagi";
              privateDefault = "kagi";
              engines = {
                "bing".metaData.hidden = true;
                "google".metaData.hidden = true;
                "duckDuckGo".metaData.hidden = true;
                "wikipedia".metaData.hidden = true;
                "perplexity".metaData.hidden = true;
                "amazondotcom-us".metaData.hidden = true;
                "ebay".metaData.hidden = true;
                kagi = {
                  urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
                  icon = "https://help.kagi.com/favicon-16x16.png";
                  definedAliases = [ "@kg" ];
                };
                nix-packages = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                nixos-wiki = {
                  urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
                  icon = "https://wiki.nixos.org/favicon.ico";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@nw" ];
                };
                home-manager = {
                  urls = [
                    {
                      template = "https://home-manager-options.extranix.com/";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "release";
                          value = "master";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@hm" ];
                };
              };
              order = [
                "kagi"
                "nix-packages"
                "nixos-wiki"
                "home-manager"
              ];
            };
            settings = {
              # --- ZEN UI ---
              "app.update.auto" = false; # disable Firefox's built-in updater (Zen updates handled by Nix/policies above)
              "svg.context-properties.content.enabled" = true; # let SVGs (e.g. sidebar icons) inherit context-fill/stroke colors from CSS
              "extensions.autoDisableScopes" = 0; # don't auto-disable extensions installed outside the Firefox store (needed for Nix-installed addons)
              "zen.sidebar.enabled" = true; # enable Zen's vertical tab sidebar UI
              "zen.urlbar.behavior" = "float"; # urlbar floats over content instead of docking in the toolbar
              "zen.workspaces.container-specific-essentials-enabled" = true; # let "essential" pinned tabs be scoped per-container instead of global
              "zen.workspaces.show-workspace-indicator" = true; # show which workspace is active in the UI
              "zen.workspaces.continue-where-left-off" = true; # reopen the last active workspace on launch
              "zen.workspaces.natural-scroll" = true; # invert scroll direction when swiping between workspaces
              "zen.view.compact.hide-tabbar" = true; # hide the horizontal tab bar in compact mode
              "zen.view.compact.hide-toolbar" = true; # hide the nav toolbar in compact mode
              "zen.welcome-screen.seen" = true; # suppress Zen's first-run welcome/onboarding screen
              "beacon.enabled" = true; # enable the Beacon API (navigator.sendBeacon) for background analytics pings
              "browser.search.region" = "US"; # locale/region used for default search engine selection
              "browser.search.isUS" = true; # treat this install as US-region for search provider defaults
              "browser.search.update" = false; # don't auto-update search engine plugins from Mozilla's list
              "browser.search.separatePrivateDefault.ui.enabled" = false; # don't offer a separate default search engine for private windows
              "browser.search.defaultenginename" = "kagi"; # legacy pref mirroring the default search engine set below
              # --- ZEN UI (extended) ---
              "zen.view.compact.animate-sidebar" = false; # disable slide animation when the sidebar auto-hides/shows
              "zen.view.compact.enable-at-startup" = false; # don't force compact mode on every browser launch
              "zen.view.experimental-rounded-view" = true; # enable Zen's experimental rounded-corner content view
              "zen.workspaces.force-container-workspace" = true; # pin each workspace to its assigned container (can't mix containers within a workspace)
              # --- ZEN COMMAND PALETTE ---
              "zen-command-palette.dynamic.about-pages" = true; # surface about:* pages (about:config, about:addons, ...) as palette commands
              "zen-command-palette.dynamic.container-tabs" = true; # surface open container tabs as jump-to commands
              "zen-command-palette.dynamic.folders" = true; # surface bookmark folders as palette commands
              "zen-command-palette.dynamic.search-engines" = true; # surface configured search engines as palette commands (e.g. "@kg query")
              "zen-command-palette.dynamic.sine-mods" = true; # surface installed Sine mods/themes as palette commands
              "zen-command-palette.dynamic.workspaces" = true; # surface workspaces as jump-to commands
              "zen-command-palette.max-commands" = 3; # max results shown per command category
              "zen-command-palette.max-commands-prefix" = 50; # max results shown when filtering by an explicit prefix (e.g. "@kg ")
              "zen-command-palette.min-query-length" = 3; # minimum characters typed before dynamic commands start matching
              "zen-command-palette.min-score-threshold" = 150; # fuzzy-match score cutoff below which results are hidden
              # --- CUSTOM CSS SUPPORT ---
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # allow userChrome.css/userContent.css to load (required for custom CSS mods)
              # --- BROWSER BEHAVIOR ---
              "browser.newtabpage.enabled" = false; # disable Firefox's built-in New Tab page content
              "browser.startup.homepage" = "chrome://browser/content/blanktab.html"; # open a truly blank page instead of New Tab/homepage on startup
              "browser.compactmode.show" = true; # expose the "Compact" density option in the UI density menu
              "browser.tabs.warnOnClose" = true; # prompt for confirmation when closing a window with multiple tabs
              "browser.safebrowsing.appRepURL" = ""; # disable Google Application Reputation lookups for downloaded files (privacy)
              "browser.urlbar.suggest.quicksuggest.sponsored" = false; # hide sponsored/Firefox Suggest results in the urlbar
              "browser.uidensity" = 1; # set UI density to "Compact" (0=normal, 1=compact, 2=touch)
              "findbar.highlightAll" = true; # highlight all matches (not just the current one) when using in-page find
              "gfx.webrender.all" = true; # force-enable the WebRender GPU compositor for rendering
              # --- EXPERIMENTS ---
              "experiments.activeExperiment" = false; # not currently enrolled in a Mozilla Normandy/SHIELD experiment
              "experiments.enabled" = false; # disable the Mozilla experiments (Normandy/SHIELD) subsystem
              "experiments.supported" = false; # report experiments as unsupported on this build
              "network.allow-experiments" = false; # block network-level experiment/study rollouts
              # --- BLOCK IMPLICIT OUTBOUND (arkenfox 0600) ---
              "network.prefetch-next" = false; # disable link prefetching (<link rel=prefetch>) hinted by pages
              "network.dns.disablePrefetch" = true; # disable DNS prefetching for links on hover/parse
              "network.dns.disablePrefetchFromHTTPS" = true; # also disable DNS prefetch when the referring page is HTTPS
              "network.http.speculative-parallel-limit" = 0; # disable speculative TCP connection warm-up (set to 0 connections)
              "browser.places.speculativeConnect.enabled" = false; # don't speculatively connect to sites shown in awesomebar/history results
              "browser.urlbar.speculativeConnect.enabled" = false; # don't speculatively connect to the highlighted urlbar autocomplete result
              # --- QUIETER FOX (arkenfox 0300) ---
              "extensions.getAddons.showPane" = false; # hide the "Recommendations" pane in about:addons (avoids AMO calls)
              "extensions.htmlaboutaddons.recommendations.enabled" = false; # disable inline addon recommendations in about:addons
              "browser.discovery.enabled" = false; # disable telemetry-based addon "Discovery" recommendations
              "browser.newtabpage.activity-stream.feeds.telemetry" = false; # disable telemetry collection from the Activity Stream (new tab) feed
              "browser.newtabpage.activity-stream.telemetry" = false; # disable Activity Stream telemetry pings generally
              # --- PASSWORDS (arkenfox 0900) ---
              "signon.autofillForms" = false; # don't auto-fill saved login forms without user interaction
              "signon.formlessCapture.enabled" = false; # don't capture credentials from forms lacking a real <form> element
              "signon.privateBrowsingCapture.enabled" = false; # don't prompt to save logins encountered in private browsing
              "network.auth.subresource-http-auth-allow" = 1; # restrict HTTP auth prompts from cross-origin subresources (1=same-origin only)
              # --- HTTPS / TLS (arkenfox 1200) ---
              "dom.security.https_only_mode" = true; # upgrade all navigations to HTTPS, warn/block on plain HTTP
              "dom.security.https_only_mode_ever_enabled" = true; # remember that HTTPS-Only was enabled at least once (affects internal exception handling)
              "security.tls.version.enable-deprecated" = false; # refuse deprecated TLS versions (TLS 1.0/1.1)
              # --- TRACKING PROTECTION ---
              "browser.contentblocking.category" = "strict"; # use Firefox's "Strict" Enhanced Tracking Protection preset (also enforced via policy above)
              "privacy.trackingprotection.socialtracking.enabled" = true; # block known social-media tracking scripts (Facebook/Twitter "Like" widgets etc.)
              # --- FINGERPRINTING / PRIVACY ---
              "dom.battery.enabled" = false; # disable the Battery Status API (fingerprinting vector)
              "geo.enabled" = false; # disable the Geolocation API entirely
              "media.navigator.enabled" = false; # disable camera/mic device enumeration (getUserMedia) fingerprinting surface
              "media.video_stats.enabled" = false; # hide video playback quality stats (fingerprinting surface)
              "privacy.donottrackheader.enabled" = true; # send the (largely ignored) DNT: 1 header on requests
              "privacy.fingerprintingProtection" = true; # enable Firefox's built-in fingerprinting resistance protections
              "privacy.firstparty.isolate" = false; # do NOT isolate cookies/storage per first-party domain (would break some cross-site OAuth flows)
              "privacy.query_stripping.enabled" = true; # strip known tracking query params (utm_*, fbclid, etc.) from URLs
              "privacy.query_stripping.enabled.pbmode" = true; # same query-param stripping, applied in private browsing windows too
              # --- GEOLOCATION (arkenfox 0200) ---
              "geo.provider.use_corelocation" = false; # don't use macOS CoreLocation for geolocation lookups (moot since geo.enabled=false)
              # --- NETWORK HARDENING ---
              "network.IDN_show_punycode" = true; # display internationalized domain names as raw punycode (xn--...) to prevent homograph spoofing
              "network.http.referer.XOriginPolicy" = 1; # only send Referer on cross-origin requests when the base domains match (0=always,1=same base domain,2=exact host)
              "network.http.referer.XOriginTrimmingPolicy" = 1; # for cross-origin requests, trim Referer to scheme+host+port+path (drop query string); same-origin referrers stay untrimmed
              "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true; # prevent sites from relaxing Referrer-Policy on cross-site top-level navigations
            };
          };
        };
      };
  };
}
