{
  pkgs,
  lib,
  user,
  inputs,
  config,
  ...
}:
let
  fx-autoconfig = pkgs.fetchFromGitHub {
    owner = "MrOtherGuy";
    repo = "fx-autoconfig";
    rev = "master";
    sha256 = "sha256-ibtYuRv21s4T+PbV0o3jRAuG/6mlaLzwWhkEivL1sho=";
  };
  sine = pkgs.fetchFromGitHub {
    owner = "CosmoCreeper";
    repo = "Sine";
    rev = "main";
    sha256 = "sha256-a6ZDi0YIuccXC7yZr93wq94vj/aeOyUZ+4aKn6U/q1Q=";
  };
  extensions =
    with pkgs.nur.repos.rycee.firefox-addons;
    [
      react-devtools
      adnauseam
      clearurls
      stylus
      proton-pass
      sponsorblock
      kagi-search
      privacy-possum
      violentmonkey
      raindropio
      don-t-fuck-with-paste
      # ublock-origin
      enhanced-h264ify
      enhanced-github
      enhancer-for-nebula
      awesome-rss
      wappalyzer
      the-camelizer-price-history-ch
      cookie-autodelete
      link-cleaner
      reddit-enhancement-suite
      libredirect
    ]
    ++ (with pkgs.firefox-addons; [
      libraryextension
      container-script
      let-s-get-color-blind
      markdown-here
      google-lighthouse
      apollo-developer-tools
      request-blocker-we
      youtube-addon
      page-shadow
      are-na
      open-graph-preview-and-debug
      openlink-structured-data-sniff
      clicktabsort
      bluesky-sidebar
      okta-browser-plugin
      remove-paywall
    ]);
in
{
  options.browser = lib.mkEnableOption "browser";
  config = {
    home.sessionVariables = {
      MOZ_LEGACY_PROFILES = 1;
      MOZ_ALLOW_DOWNGRADE = 1;
    };
    home.file."Library/Application\ Support/Zen/Profiles/wuz/chrome" = {
      recursive = true;
      enable = true;
      force = true;
      source = "${fx-autoconfig}/profile/chrome";
    };
    home.file."Library/Application\ Support/Zen/Profiles/wuz/chrome/JS/sine.us.mjs" = {
      enable = true;
      force = true;
      source = "${sine}/sine.us.mjs";
    };
    home.file."Library/Application\ Support/Zen/Profiles/wuz/chrome/JS/engine" = {
      recursive = true;
      enable = true;
      force = true;
      source = "${sine}/engine";
    };
    programs.zen-browser = {
      enable = true;
      package =
        (pkgs.wrapFirefox.override {
          libcanberra-gtk3 = pkgs.libcanberra-gtk2;
        })
          inputs.zen-browser.packages."${pkgs.system}".twilight-unwrapped
          { };
      extraPrefsFiles = [
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
          sha256 = "sha256-gNxCEmSj6gQnXhckt7VyNPiSVOlYKmwX6akRtlw6ptc=";
        })
      ];
      policies = {
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        HardwareAcceleration = true;
        AppAutoUpdate = false;
        DisableAppUpdate = true;
        ExtensionSettings = builtins.listToAttrs (
          builtins.map (
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
          default = "Kagi";
          privateDefault = "Kagi";
          engines = {
            bing.metaData.hidden = true;
            google.metaData.hidden = true;
            ddg.metaData.hidden = true;
            wikipedia.metaData.hidden = true;
            perplexity.metaData.hidden = true;
            "Kagi" = {
              urls = [
                {
                  template = "https://kagi.com/search?q={searchTerms}";
                }
              ];
              icon = "https://help.kagi.com/favicon-16x16.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@kg" ];
            };
            "Nix Packages" = {
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
            "NixOS Wiki" = {
              urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
              icon = "https://wiki.nixos.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "Home Manager NixOs" = {
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
                      value = "master"; # unstable
                    }
                  ];
                }
              ];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
            };
          };
          order = [
            "Kagi"
            "Startpage"
            "Nix Packages"
            "NixOS Wiki"
          ];
        };
        settings = {
          "app.update.auto" = false;
          "svg.context-properties.content.enabled" = true;
          "extensions.autoDisableScopes" = 0;
          "zen.sidebar.enabled" = true;
          "zen.urlbar.behavior" = "floating-on-type";
          "zen.workspaces.container-specific-essentials-enabled" = true;
          "zen.workspaces.show-workspace-indicator" = true;
          "zen.workspaces.continue-where-left-off" = true;
          "zen.workspaces.natural-scroll" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.compact.animate-sidebar" = false;
          "zen.welcome-screen.seen" = true;
          "zen.view.experimental-rounded-view" = true;

          "beacon.enabled" = false;
        };
      };
    };
  };
}
