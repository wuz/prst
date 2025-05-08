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
      decentraleyes
      tampermonkey
      raindropio
      don-t-fuck-with-paste
    ]
    ++ (with pkgs.firefox-addons; [
      libraryextension
      container-script
      let-s-get-color-blind
      markdown-here
      google-lighthouse
      request-blocker-we
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
      package = pkgs.zen-browser-bin;
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
          TTRPG = {
            color = "purple";
            icon = "fruit";
            id = 3;
          };
          Work = {
            color = "yellow";
            icon = "briefcase";
            id = 2;
          };
          Personal = {
            color = "blue";
            icon = "chill";
            id = 1;
          };
        };
        containersForce = true;
        search.force = true;
        search.default = "Kagi";
        search.engines = {
          "Bing".metaData.hidden = true;
          "Google".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
          "Kagi" = {
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            definedAliases = [ "@kagi" ];
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
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@hm" ];
          };
        };
        settings = {
          "app.update.auto" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "extensions.autoDisableScopes" = 0;
          "zen.sidebar.enabled" = true;
          "zen.urlbar.behavior" = "floating-on-type";
          "zen.workspaces.container-specific-essentials-enabled" = true;
          "zen.workspaces.show-workspace-indicator" = false;
          "zen.view.experimental-rounded-view" = true;

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
          #   "cookiebanners.service.mode" = 1;
          #   "cookiebanners.service.mode.privateBrowsing" = 1;
          #   "cookiebanners.service.enableGlobalRules" = true;
          #   # disable welcome page
          #   "browser.aboutwelcome.enabled" = false;
          #   # dark:0 light:1 system:2 browser:3
          #   "layout.css.prefers-color-scheme.content-override" = 0;
          #   # telemetry
          # "datareporting.policy.dataSubmissionEnabled" = false;
          # "datareporting.healthreport.uploadEnabled" = false;
          # "toolkit.telemetry.unified" = false;
          # "toolkit.telemetry.enabled" = false;
          # "toolkit.telemetry.server" = "data:,";
          # "toolkit.telemetry.archive.enabled" = false;
          # "toolkit.telemetry.newProfilePing.enabled" = false;
          # "toolkit.telemetry.shutdownPingSender.enabled" = false;
          # "toolkit.telemetry.updatePing.enabled" = false;
          # "toolkit.telemetry.bhrPing.enabled" = false;
          # "toolkit.telemetry.firstShutdownPing.enabled" = false;
          # "toolkit.telemetry.coverage.opt-out" = true;
          # "toolkit.coverage.opt-out" = true;
          # "toolkit.coverage.endpoint.base" = "";
          # "browser.ping-centre.telemetry" = false;
          #   # passwords
          "signon.rememberSignons" = false;
          "signon.formlessCapture.enabled" = false;
          "signon.privateBrowsingCapture.enabled" = false;
          # "network.auth.subresource-http-auth-allow" = 1;
          #   # address + credit card manager
          #   "extensions.formautofill.addresses.enabled" = false;
          #   "extensions.formautofill.creditCards.enabled" = false;
        };
      };
    };
  };
}
