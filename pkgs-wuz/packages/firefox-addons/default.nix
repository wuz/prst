{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "arcfox" = buildFirefoxXpiAddon {
      pname = "arcfox";
      version = "2.5.3";
      addonId = "{8a65567e-d1bc-4494-a266-b3d300c106f8}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4352827/arcfox-2.5.3.xpi";
      sha256 = "b986cab8a396833872cae8124f03a63b568efc623f62a79a521a511c0dc32e45";
      meta = with lib;
      {
        homepage = "https://github.com/betterbrowser/arcfox";
        description = "Make firefox flow like arc";
        license = licenses.mit;
        mozPermissions = [
          "<all_urls>"
          "webRequest"
          "webRequestBlocking"
          "activeTab"
          "bookmarks"
          "tabs"
          "storage"
          "search"
        ];
        platforms = platforms.all;
      };
    };
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
    "google-lighthouse" = buildFirefoxXpiAddon {
      pname = "google-lighthouse";
      version = "100.0.0.3";
      addonId = "{cf3dba12-a848-4f68-8e2d-f9fadc0721de}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4148676/google_lighthouse-100.0.0.3.xpi";
      sha256 = "49cb8c94d536e1f49b76a3e75e8cd0c361961061da53039abbc5db755944afb9";
      meta = with lib;
      {
        homepage = "https://github.com/GoogleChrome/lighthouse";
        description = "Lighthouse is an open-source, automated tool for improving the performance, quality, and correctness of your web apps.";
        mozPermissions = [ "activeTab" "storage" ];
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
      version = "2025.113.1";
      addonId = "firefox@libraryextension.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4418697/libraryextension-2025.113.1.xpi";
      sha256 = "e98edc748d92aea46ffb4422f16524237308e56a9e5fa6c26fbc3705ad711a5b";
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
    "markdown-here" = buildFirefoxXpiAddon {
      pname = "markdown-here";
      version = "2.14.2";
      addonId = "markdown-here-webext@adam.pritchard";
      url = "https://addons.mozilla.org/firefox/downloads/file/4385206/markdown_here-2.14.2.xpi";
      sha256 = "410c603f5e13c1023bd4dbe185ff4f9d6e96abbf4e8fd0b91f9cb31fa288f9b5";
      meta = with lib;
      {
        homepage = "https://github.com/adam-p/markdown-here";
        description = "Write your email in Markdown, then make it pretty.";
        license = licenses.mit;
        mozPermissions = [
          "contextMenus"
          "storage"
          "http://*/*"
          "https://*/*"
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
    "request-blocker-we" = buildFirefoxXpiAddon {
      pname = "request-blocker-we";
      version = "0.6.2";
      addonId = "{8b0dd2c0-b9e8-46d5-b360-e2c53e43f2bc}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4193619/request_blocker_we-0.6.2.xpi";
      sha256 = "88a1bb807502c7fcc8f526b602298a8a71f9a44b85425f488e641afe1ef490e9";
      meta = with lib;
      {
        description = "Block requests with URL match patterns";
        mozPermissions = [
          "storage"
          "webRequest"
          "webRequestBlocking"
          "<all_urls>"
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