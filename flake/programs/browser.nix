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
            mozeidon
          ]);
      in
      {
        imports = [ inputs.zen-browser.homeModules.twilight ];

        # Install mozeidon native messaging manifest directly instead of via
        # nativeMessagingHosts, which triggers a glob expansion bug in wrapFirefox
        # with structuredAttrs (ln -sfLt .../* fails in the Nix sandbox).
        home.file."Library/Application Support/Mozilla/NativeMessagingHosts/mozeidon.json".source =
          "${pkgs.mozeidon-native-app}/lib/mozilla/native-messaging-hosts/mozeidon.json";

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

        programs.zen-browser = {
          darwinDefaultsId = "app.zen-browser.zen";
          enable = true;
          # mozeidon native messaging host is installed via home.file below
          # to avoid the nativeMessagingHosts glob expansion bug in wrapFirefox
          # with structuredAttrs (nixpkgs issue with ln -sfLt .../*).
          nativeMessagingHosts = [ ];
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
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
              EmailTracking = true;
              Exceptions = [
                "https://raindrop.io"
                "https://app.raindrop.io"
                "https://api.raindrop.io"
              ];
            };
            Cookies = {
              Allow = [
                "https://raindrop.io"
                "https://app.raindrop.io"
                "https://api.raindrop.io"
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
              "app.update.auto" = false;
              "svg.context-properties.content.enabled" = true;
              "extensions.autoDisableScopes" = 0;
              "zen.sidebar.enabled" = true;
              "zen.urlbar.behavior" = "float";
              "zen.workspaces.container-specific-essentials-enabled" = true;
              "zen.workspaces.show-workspace-indicator" = true;
              "zen.workspaces.continue-where-left-off" = true;
              "zen.workspaces.natural-scroll" = true;
              "zen.view.compact.hide-tabbar" = true;
              "zen.view.compact.hide-toolbar" = true;
              "zen.welcome-screen.seen" = true;
              "beacon.enabled" = true;
              "browser.search.region" = "US";
              "browser.search.isUS" = true;
              "browser.search.update" = false;
              "browser.search.separatePrivateDefault.ui.enabled" = false;
              "browser.search.defaultenginename" = "kagi";
              # --- ZEN UI (extended) ---
              "zen.view.compact.animate-sidebar" = false;
              "zen.view.compact.enable-at-startup" = false;
              "zen.view.experimental-rounded-view" = true;
              "zen.workspaces.force-container-workspace" = true;
              # --- ZEN COMMAND PALETTE ---
              "zen-command-palette.dynamic.about-pages" = true;
              "zen-command-palette.dynamic.container-tabs" = true;
              "zen-command-palette.dynamic.folders" = true;
              "zen-command-palette.dynamic.search-engines" = true;
              "zen-command-palette.dynamic.sine-mods" = true;
              "zen-command-palette.dynamic.workspaces" = true;
              "zen-command-palette.max-commands" = 3;
              "zen-command-palette.max-commands-prefix" = 50;
              "zen-command-palette.min-query-length" = 3;
              "zen-command-palette.min-score-threshold" = 150;
              # --- CUSTOM CSS SUPPORT ---
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              # --- BROWSER BEHAVIOR ---
              "browser.newtabpage.enabled" = false;
              "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
              "browser.compactmode.show" = true;
              "browser.tabs.warnOnClose" = true;
              "browser.safebrowsing.appRepURL" = "";
              "browser.urlbar.suggest.quicksuggest.sponsored" = false;
              "browser.uidensity" = 1;
              "findbar.highlightAll" = true;
              "gfx.webrender.all" = true;
              # --- EXPERIMENTS ---
              "experiments.activeExperiment" = false;
              "experiments.enabled" = false;
              "experiments.supported" = false;
              "network.allow-experiments" = false;
              # --- BLOCK IMPLICIT OUTBOUND (arkenfox 0600) ---
              "network.prefetch-next" = false;
              "network.dns.disablePrefetch" = true;
              "network.dns.disablePrefetchFromHTTPS" = true;
              "network.http.speculative-parallel-limit" = 0;
              "browser.places.speculativeConnect.enabled" = false;
              "browser.urlbar.speculativeConnect.enabled" = false;
              # --- QUIETER FOX (arkenfox 0300) ---
              "extensions.getAddons.showPane" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "browser.discovery.enabled" = false;
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              # --- PASSWORDS (arkenfox 0900) ---
              "signon.autofillForms" = false;
              "signon.formlessCapture.enabled" = false;
              "signon.privateBrowsingCapture.enabled" = false;
              "network.auth.subresource-http-auth-allow" = 1;
              # --- HTTPS / TLS (arkenfox 1200) ---
              "dom.security.https_only_mode" = true;
              "dom.security.https_only_mode_ever_enabled" = true;
              "security.tls.version.enable-deprecated" = false;
              # --- TRACKING PROTECTION ---
              "browser.contentblocking.category" = "strict";
              "privacy.trackingprotection.socialtracking.enabled" = true;
              # --- FINGERPRINTING / PRIVACY ---
              "dom.battery.enabled" = false;
              "geo.enabled" = false;
              "media.navigator.enabled" = false;
              "media.video_stats.enabled" = false;
              "privacy.donottrackheader.enabled" = true;
              "privacy.fingerprintingProtection" = true;
              "privacy.firstparty.isolate" = false;
              "privacy.query_stripping.enabled" = true;
              "privacy.query_stripping.enabled.pbmode" = true;
              # --- GEOLOCATION (arkenfox 0200) ---
              "geo.provider.use_corelocation" = false;
              # --- NETWORK HARDENING ---
              "network.IDN_show_punycode" = true;
              "network.http.referer.XOriginPolicy" = 1;
              "network.http.referer.XOriginTrimmingPolicy" = 1;
              "network.http.referer.trimmingPolicy" = 1;
              "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
            };
          };
        };
      };
  };
}
