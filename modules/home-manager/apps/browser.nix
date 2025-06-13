{
  pkgs,
  lib,
  user,
  ...
}:
let
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
      ublock-origin
      enhanced-h264ify
      enhanced-github
      enhancer-for-nebula
      awesome-rss
      wappalyzer
      the-camelizer-price-history-ch
      yang
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
      rss-reader-extension-inoreader
      open-graph-preview-and-debug
      openlink-structured-data-sniff
      # zen-internet
      clicktabsort
      adaptive-theme-creator
      bluesky-sidebar
    ]);
in
{
  options.browser = lib.mkEnableOption "browser";
  config = {
    home.sessionVariables = {
      MOZ_LEGACY_PROFILES = 1;
      MOZ_ALLOW_DOWNGRADE = 1;
    };
    programs.zen-browser = {
      package = null;
      enable = true;
      policies = {
        AppAutoUpdate = false;
        DisableAppUpdate = true;
        ExtensionSettings = builtins.listToAttrs (
          builtins.map (
            e:
            lib.nameValuePair e.addonId {
              installation_mode = "force_installed";
              install_url = "file://${e.src}";
              updates_disabled = true;
            }
          ) extensions
        );
      };
      profiles.wuz = {
        isDefault = true;
        extensions = extensions;
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
        containersForce = true;
        search.force = true;
        search.default = "Kagi";
        search.privateDefault = "Kagi";
        search.order = [ "Kagi" ];
        search.engines = {
          "Kagi" = {
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            definedAliases = [ "@kagi" ];
          };
          "Bing".metaData.hidden = true;
          "Google".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
          "Home Manager NixOs" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@hm" ];
          };
        };
        settings = {
          "app.update.auto" = false;
          "svg.context-properties.content.enabled" = true;
          "extensions.autoDisableScopes" = 0;
          "zen.sidebar.enabled" = true;
          "zen.urlbar.behavior" = "floating-on-type";
          "zen.workspaces.container-specific-essentials-enabled" = true;
          "zen.workspaces.show-workspace-indicator" = false;
          "zen.view.experimental-rounded-view" = true;

          "beacon.enabled" = false;
          "browser.contentblocking.category" = "strict";
          "browser.display.os-zoom-behavior" = 1;
          "browser.newtabpage.enabled" = false; # Blank new tab page.
          "browser.safebrowsing.appRepURL" = "";
          "browser.safebrowsing.malware.enabled" = false;
          "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter";
          "browser.search.suggest.enabled" = false;
          "browser.send_pings" = false;
          "browser.startup.page" = 3; # Resume last session.
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.uidensity" = 1; # Dense.
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.urlbar.speculativeConnect.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.security.https_only_mode" = true;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "extensions.unifiedExtensions.enabled" = false;
          "general.smoothScroll" = false;
          "geo.enabled" = false;
          "gfx.webrender.all" = true;
          "layout.css.devPixelsPerPx" = 1;
          # Follow system color theme.
          "layout.css.prefers-color-scheme.content-override" = 2;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.navigator.enabled" = false;
          "media.video_stats.enabled" = false;
          "network.IDN_show_punycode" = true;
          "network.allow-experiments" = false;
          "network.dns.disablePrefetch" = true;
          "network.http.referer.XOriginPolicy" = 1;
          "network.http.referer.XOriginTrimmingPolicy" = 1;
          "network.http.referer.trimmingPolicy" = 1;
          "network.prefetch-next" = false;
          "permissions.default.shortcuts" = 2; # Don't steal my shortcuts!
          "privacy.donottrackheader.enabled" = true;
          "privacy.donottrackheader.value" = 1;
          "privacy.firstparty.isolate" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "ui.textScaleFactor" = 100;

          # new tab page
          # "browser.newtabpage.activity-stream.feeds.topsites" = false;
          # "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          #   "browser.display.background_color.dark" = "#1e1e2e";
          #   "browser.discovery.enabled" = false;
          #   "browser.download.useDownloadDir" = false;
          #   "browser.startup.homepage" = "about:blank";
          #   "general.smoothScroll" = true;
          #   "signon.autofillForms" = false;
          #   "widget.non-native-theme.scrollbar.style" = 3;
          #   "browser.uidensity" = 1;
          #   "browser.compactmode.show" = true;
          #   "breakpad.reportURL" = "";
          #   "browser.tabs.crashReporting.sendReport" = false;
          #   "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          #   "browser.urlbar.suggest.calculator" = true;
          #   "browser.aboutConfig.showWarning" = false;
          #   "extensions.htmlaboutaddons.recommendations.enabled" = false;
          #   "extensions.getAddons.showPane" = false;
          #   "extensions.postDownloadThirdPartyPrompt" = false;
          #   "browser.preferences.moreFromMozilla" = false;
          #   "browser.tabs.tabmanager.enabled" = false;
          # "browser.toolbars.bookmarks.visibility" = "never";
          #   # alt will not open menu
          #   "ui.key.menuAccessKeyFocuses" = false;
          #   # new tabs are added at the end of the tab list, not next to the current tab
          #   "browser.tabs.insertRelatedAfterCurrent" = true;
          #   # disable full screen fade animation
          #   "full-screen-api.transition-duration.enter" = "0 0";
          #   "full-screen-api.transition-duration.leave" = "0 0";
          #   "full-screen-api.transition.timeout" = 0;
          #   # disable address bar hiding in fullscreen mode
          #   "browser.fullscreen.autohide" = false;
          #   "full-screen-api.warning.delay" = 0;
          #   # disable message "... is now fullscreen"
          #   "full-screen-api.warning.timeout" = 0;
          #   # cookie banner handling
          "cookiebanners.service.mode" = 1;
          "cookiebanners.service.mode.privateBrowsing" = 1;
          "cookiebanners.service.enableGlobalRules" = true;
          # passwords
          "signon.rememberSignons" = false;
          "signon.formlessCapture.enabled" = false;
          "signon.privateBrowsingCapture.enabled" = false;
          "network.auth.subresource-http-auth-allow" = 1;
          # address + credit card manager
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
        };
      };
    };
  };
}
