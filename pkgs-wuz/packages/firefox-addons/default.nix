{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "adaptive-theme-creator" = buildFirefoxXpiAddon {
      pname = "adaptive-theme-creator";
      version = "2.1";
      addonId = "{3aebb6e1-b5e5-440f-a5e7-1fe875078e3d}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4331747/favicon_color-2.1.xpi";
      sha256 = "92fdd52ebf5e719d2d784bec033ea24370441c320a7e1c6879e84cbe2aafd551";
      meta = with lib;
      {
        homepage = "https://github.com/aminought/firefox-adaptive-theme-creator";
        description = "A Firefox extension that allows you to create a unique adaptive theme for your browser. Like Adaptive Tab Bar Colour or VivaldiFox, but better.";
        license = licenses.mpl20;
        mozPermissions = [ "theme" "tabs" "storage" "<all_urls>" ];
        platforms = platforms.all;
      };
    };
    "apollo-developer-tools" = buildFirefoxXpiAddon {
      pname = "apollo-developer-tools";
      version = "4.19.13";
      addonId = "{a5260852-8d08-4979-8116-38f1129dfd22}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4471757/apollo_developer_tools-4.19.13.xpi";
      sha256 = "43afa492f3e3445cb1dba4d6399534ced6706eeb9bd934c91b86ee1ba9f4d52d";
      meta = with lib;
      {
        homepage = "https://www.apollographql.com";
        description = "GraphQL debugging tools for Apollo Client.";
        license = licenses.mit;
        mozPermissions = [ "devtools" "<all_urls>" ];
        platforms = platforms.all;
      };
    };
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
    "are-na" = buildFirefoxXpiAddon {
      pname = "are-na";
      version = "2.11.0";
      addonId = "{4245110a-2f3e-4f78-8303-10cae12384cc}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4501779/are_na-2.11.0.xpi";
      sha256 = "d4c6b8dac0ae658175336838a1b469fb9942e9b83c76edc87ab0995f7a8a5983";
      meta = with lib;
      {
        homepage = "https://www.are.na";
        description = "Assemble and connect information.";
        license = licenses.mit;
        mozPermissions = [ "activeTab" "contextMenus" "storage" "<all_urls>" ];
        platforms = platforms.all;
      };
    };
    "bluesky-sidebar" = buildFirefoxXpiAddon {
      pname = "bluesky-sidebar";
      version = "0.0.10";
      addonId = "{42f52678-fbed-4a73-88dd-b01f94d06cdb}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4497122/bluesky_sidebar-0.0.10.xpi";
      sha256 = "f6e6f6ef63a6860d191432d7b288b4d72c0f6a6352a7f28a209122afdfeacc3e";
      meta = with lib;
      {
        homepage = "https://github.com/hzoo/extension-annotation-sidebar";
        description = "See what people are saying about the site you're on";
        license = licenses.mit;
        mozPermissions = [
          "storage"
          "tabs"
          "identity"
          "contextMenus"
          "<all_urls>"
        ];
        platforms = platforms.all;
      };
    };
    "clicktabsort" = buildFirefoxXpiAddon {
      pname = "clicktabsort";
      version = "3.2.1";
      addonId = "{9a51d52f-40fa-44c6-9c62-66936e43c4db}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3614940/clicktabsort-3.2.1.xpi";
      sha256 = "01ca403a8ea806bbe67f2a22222a00501659b1cc372b4b846b47ddd699f0353b";
      meta = with lib;
      {
        description = "Sort tabs from the right click menu.";
        license = licenses.mpl20;
        mozPermissions = [ "contextMenus" "notifications" "storage" "tabs" ];
        platforms = platforms.all;
      };
    };
    "container-script" = buildFirefoxXpiAddon {
      pname = "container-script";
      version = "1.2";
      addonId = "{fa0585bd-e256-4a38-ae72-a6f66d439644}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4419892/container_script-1.2.xpi";
      sha256 = "1c00bbac7d04e6af5afa067caaf62f44a31053a3a89a08e2d42ae7f32c114fe6";
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
    "enhanced-h264ify" = buildFirefoxXpiAddon {
      pname = "enhanced-h264ify";
      version = "2.2.1";
      addonId = "{9a41dee2-b924-4161-a971-7fb35c053a4a}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4295701/enhanced_h264ify-2.2.1.xpi";
      sha256 = "68bf0cd6b2c26de24f263eb76848886665423b73c3f055633dcdbde51d2a35a9";
      meta = with lib;
      {
        homepage = "https://github.com/alextrv/enhanced-h264ify";
        description = "Choose what video codec YouTube should play for you";
        license = licenses.mit;
        mozPermissions = [
          "storage"
          "*://*.youtube.com/*"
          "*://*.youtube-nocookie.com/*"
          "*://*.youtu.be/*"
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
      version = "2025.224.1";
      addonId = "firefox@libraryextension.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4442775/libraryextension-2025.224.1.xpi";
      sha256 = "f4e5e1e2b27d24f1efee5895eb8f7b5df878ac84890362aec04d5b5d9fbf29d4";
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
    "open-graph-preview-and-debug" = buildFirefoxXpiAddon {
      pname = "open-graph-preview-and-debug";
      version = "1.0.4";
      addonId = "{6e262423-d612-4f29-be6e-e83aa641645d}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4049194/open_graph_preview_and_debug-1.0.4.xpi";
      sha256 = "856c666a8999cfa91b0137aa8c22510de40f65a481e0fd2fd738bdc8752ac5e8";
      meta = with lib;
      {
        description = "Shows approximately what users will see if this webpage is shared on websites that uses OG tags to display a preview.\nLet you detect if no Open Graph Tags are set on your webpage !\nThe shown preview is inspired from the Facebook one.";
        license = licenses.mpl20;
        mozPermissions = [ "activeTab" ];
        platforms = platforms.all;
      };
    };
    "openlink-structured-data-sniff" = buildFirefoxXpiAddon {
      pname = "openlink-structured-data-sniff";
      version = "3.4.8";
      addonId = "osds@openlinksw.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4386946/openlink_structured_data_sniff-3.4.8.xpi";
      sha256 = "1cb2e2923162853354554647f683e4e4500c2b7f66120535ceee8059085fc8ae";
      meta = with lib;
      {
        homepage = "http://osds.openlinksw.com/";
        description = "Adds structured data discovery and handling of multiple content-types to your browser. Reveals Structured Metadata embedded within HTML pages in notations including POSH (Plain Old Semantic HTML), Microdata, JSON-LD, RDF-Turtle, and RDFa.";
        license = licenses.mpl20;
        mozPermissions = [
          "storage"
          "webRequest"
          "contextMenus"
          "scripting"
          "declarativeNetRequest"
          "file:///*/*"
          "*://*/*"
          "https://openlinksoftware.github.io/*"
        ];
        platforms = platforms.all;
      };
    };
    "page-shadow" = buildFirefoxXpiAddon {
      pname = "page-shadow";
      version = "2.11.3";
      addonId = "page-shadow@eliastiksofts.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4468899/page_shadow-2.11.3.xpi";
      sha256 = "90b04ab11737a2caefabf95c0fa2634de455285561e3da2bfd64d6f4b84651fb";
      meta = with lib;
      {
        homepage = "http://www.eliastiksofts.com/page-shadow/";
        description = "An extension for Chrome/Chromium, Firefox, Opera and Edge designed to render a web page more readable in a dark environment by decreasing page brightness or by increasing page contrast. This extension also have a night mode and others tools.";
        license = licenses.gpl3;
        mozPermissions = [
          "storage"
          "contextMenus"
          "tabs"
          "<all_urls>"
          "unlimitedStorage"
          "http://*/*"
          "https://*/*"
          "ftp://*/*"
          "file:///*/*"
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
      version = "6.0.6";
      addonId = "inodhwnfgtr463428675drebcs@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/4512762/rss_reader_extension_inoreader-6.0.6.xpi";
      sha256 = "95525bbdfae3bb3a24477c90b37030ccd568c3a078aee37f7d97fc412f4bd3bd";
      meta = with lib;
      {
        homepage = "https://www.inoreader.com";
        description = "Build your own newsfeed!";
        license = licenses.mpl20;
        mozPermissions = [
          "activeTab"
          "storage"
          "contextMenus"
          "scripting"
          "*://*.inoreader.com/*"
        ];
        platforms = platforms.all;
      };
    };
    "youtube-addon" = buildFirefoxXpiAddon {
      pname = "youtube-addon";
      version = "4.1280";
      addonId = "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4507978/youtube_addon-4.1280.xpi";
      sha256 = "0393b0db010fceafbf213f358751491dfafcdcd1654dcf429163a7cca6463723";
      meta = with lib;
      {
        homepage = "https://github.com/code4charity/YouTube-Extension/";
        description = "Youtube Extension. Powerful but lightweight. Enrich your Youtube and content selection. Make YouTube tidy and smart! (Layout, Filters, Shortcuts, Playlist)";
        mozPermissions = [
          "contextMenus"
          "storage"
          "https://www.youtube.com/*"
          "https://m.youtube.com/*"
        ];
        platforms = platforms.all;
      };
    };
    "zen-internet" = buildFirefoxXpiAddon {
      pname = "zen-internet";
      version = "2.3.1";
      addonId = "{91aa3897-2634-4a8a-9092-279db23a7689}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4507755/zen_internet-2.3.1.xpi";
      sha256 = "eb50e4d65aa8f8060b47015eb12abb9c53b6b5c2fabde5566ba1e80f3d059552";
      meta = with lib;
      {
        homepage = "https://www.sameerasw.com";
        description = "Inject custom css to make the web beautiful in Zen Browser";
        license = licenses.mit;
        mozPermissions = [
          "activeTab"
          "storage"
          "tabs"
          "<all_urls>"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
        ];
        platforms = platforms.all;
      };
    };
  }