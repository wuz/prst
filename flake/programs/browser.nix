{ inputs, lib, ... }:
{
  conlin.browser = {
    homeManager =
      { pkgs, config, ... }:
      let
        cfg_orig = config.programs.zen-browser;
        zen-package = (
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight-unwrapped.override {
            policies = cfg_orig.policies;
          }
        );
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
            libraryextension
            container-script
            markdown-here
            google-lighthouse
            open-graph-previewer
            openlink-structured-data-sniff
            remove-paywall
          ]);
      in
      {
        imports = [ inputs.zen-browser.homeModules.beta ];

        home.sessionVariables = {
          MOZ_LEGACY_PROFILES = 1;
          MOZ_ALLOW_DOWNGRADE = 1;
        };

        programs.zen-browser = {
          darwinDefaultsId = "app.zen-browser.zen";
          enable = true;
          package = (pkgs.wrapFirefox zen-package { icon = "zen"; }).override {
            extraPrefs = cfg_orig.extraPrefs;
            extraPrefsFiles = cfg_orig.extraPrefsFiles;
            nativeMessagingHosts = cfg_orig.nativeMessagingHosts;
          };
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
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
            ExtensionUpdate = true;
            ExtensionSettings = builtins.listToAttrs (
              map (
                e:
                lib.nameValuePair e.addonId {
                  install_url = "file://${e.src}";
                  installation_mode = "force_installed";
                }
              ) extensions
            );
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
            };
          };
        };
      };
  };
}
