{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "container-script" = buildFirefoxXpiAddon {
      pname = "container-script";
      version = "1.1";
      addonId = "{fa0585bd-e256-4a38-ae72-a6f66d439644}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4397851/container_script-1.1.xpi";
      sha256 = "3786b569d5404b91e35bde5c1174d54484e99adae53d6a66c59e5a3f936d7b1d";
      meta = with lib;
      {
        homepage = "https://github.com/icholy/ContainerScript";
        description = "User defined scripts for assigning URLs to containers.";
        license = licenses.mit;
        mozPermissions = [
          "<all_urls>"
          "contextualIdentities"
          "cookies"
          "webRequestBlocking"
          "webRequest"
          "tabs"
          "storage"
        ];
        platforms = platforms.all;
      };
    };
    "google-container" = buildFirefoxXpiAddon {
      pname = "google-container";
      version = "1.5.4";
      addonId = "@contain-google";
      url = "https://addons.mozilla.org/firefox/downloads/file/3736912/google_container-1.5.4.xpi";
      sha256 = "47a7c0e85468332a0d949928d8b74376192cde4abaa14280002b3aca4ec814d0";
      meta = with lib;
      {
        homepage = "https://github.com/containers-everywhere/contain-google";
        description = "THIS IS NOT AN OFFICIAL ADDON FROM MOZILLA!\nIt is a fork of the Facebook Container addon.\n\nPrevent Google from tracking you around the web. The Google Container extension helps you take control and isolate your web activity from Google.";
        license = licenses.mpl20;
        mozPermissions = [
          "<all_urls>"
          "contextualIdentities"
          "cookies"
          "management"
          "tabs"
          "webRequestBlocking"
          "webRequest"
          "storage"
        ];
        platforms = platforms.all;
      };
    };
    "let-s-get-color-blind" = buildFirefoxXpiAddon {
      pname = "let-s-get-color-blind";
      version = "1.0.1resigned1";
      addonId = "letsgetcolorblind@hilberteikelboom.nl";
      url = "https://addons.mozilla.org/firefox/downloads/file/4273928/let_s_get_color_blind-1.0.1resigned1.xpi";
      sha256 = "aba501e26d25a147cc43418ea5306ebbe6e7ad342b630997027e5802db07f12b";
      meta = with lib;
      {
        description = "Simulates information a color blind person receives and/or adds a daltonization filter.\nThis addon can be used for testing a website accessibility for the color blind and / or to educate (yourself) on the topic of color blindness.";
        license = licenses.mpl20;
        mozPermissions = [
          "https://*/*"
          "http://*/*"
          "<all_urls>"
          "tabs"
          "storage"
        ];
        platforms = platforms.all;
      };
    };
    "libraryextension" = buildFirefoxXpiAddon {
      pname = "libraryextension";
      version = "2024.409.1";
      addonId = "firefox@libraryextension.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4262179/libraryextension-2024.409.1.xpi";
      sha256 = "2c10189642e43b961ac2f0027062cafc9be7c5c90783a395831a7e4ce5c8f4aa";
      meta = with lib;
      {
        homepage = "https://www.libraryextension.com/";
        description = "See books, music and more at your local library as you browse the internet";
        mozPermissions = [
          "tabs"
          "http://*/*"
          "https://*/*"
          "https://www.libraryextension.com/*"
          "https://api.libraryextension.com/*"
        ];
        platforms = platforms.all;
      };
    };
    "microsoft-container" = buildFirefoxXpiAddon {
      pname = "microsoft-container";
      version = "1.0.4";
      addonId = "@contain-microsoft";
      url = "https://addons.mozilla.org/firefox/downloads/file/3711415/microsoft_container-1.0.4.xpi";
      sha256 = "8780c9edcfa77a9f3eaa7da228a351400c42a884fec732cafc316e07f55018d3";
      meta = with lib;
      {
        homepage = "https://github.com/kouassi-goli/contain-microsoft";
        description = "This add-on is an unofficial fork of Mozilla's Facebook Container designed for Microsoft. \n Microsoft Container isolates your Microsoft activity from the rest of your web activity and prevent Microsoft from tracking you outside of the its website.";
        license = licenses.mpl20;
        mozPermissions = [
          "<all_urls>"
          "contextualIdentities"
          "cookies"
          "management"
          "tabs"
          "webRequestBlocking"
          "webRequest"
        ];
        platforms = platforms.all;
      };
    };
    "rss-reader-extension-inoreader" = buildFirefoxXpiAddon {
      pname = "rss-reader-extension-inoreader";
      version = "5.1.5";
      addonId = "inodhwnfgtr463428675drebcs@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/4096839/rss_reader_extension_inoreader-5.1.5.xpi";
      sha256 = "963d796ea2b3ebe554c39bc4bac9f3ee393a1e188d15e9764eb253603ea20e51";
      meta = with lib;
      {
        homepage = "https://www.inoreader.com";
        description = "Build your own newsfeed";
        license = licenses.mpl20;
        mozPermissions = [ "activeTab" "storage" "*://*.inoreader.com/*" ];
        platforms = platforms.all;
      };
    };
  }