{ buildMozillaXpiAddon, lib }: {

  "adaptive-theme-creator" = buildMozillaXpiAddon {
    pname = "adaptive-theme-creator";
    version = "2.1";
    addonId = "{3aebb6e1-b5e5-440f-a5e7-1fe875078e3d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4331747/favicon_color-2.1.xpi";
    sha256 = "92fdd52ebf5e719d2d784bec033ea24370441c320a7e1c6879e84cbe2aafd551";
    meta = with lib; {
      homepage = "https://github.com/aminought/firefox-adaptive-theme-creator";
      description = "A Firefox extension that allows you to create a unique adaptive theme for your browser. Like Adaptive Tab Bar Colour or VivaldiFox, but better.";
      license = licenses.mpl20;
      mozPermissions = [
        "theme"
        "tabs"
        "storage"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "almost-dark-proton" = buildMozillaXpiAddon {
    pname = "almost-dark-proton";
    version = "3.0";
    addonId = "{9127a9dd-5aa0-4d43-833f-59f2432f5776}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3770440/almost_dark_proton-3.0.xpi";
    sha256 = "0bdc7b06afe4a6c0eaab5d47b1502dfbe8de3a91f04d75609436228aeaaa105b";
    meta = with lib; {
      description = "A borderless Almost dark theme for Firefox 89 and beyond";
      license = licenses.cc-by-30;
      mozPermissions = [ ];
      platforms = platforms.all;
    };
  };
  "apollo-developer-tools" = buildMozillaXpiAddon {
    pname = "apollo-developer-tools";
    version = "4.25.6";
    addonId = "{a5260852-8d08-4979-8116-38f1129dfd22}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4785566/apollo_developer_tools-4.25.6.xpi";
    sha256 = "17f268cbc5986cb9ad70097e8e0f4f5a9f291473b1132967ac543a37c998eaec";
    meta = with lib; {
      homepage = "https://www.apollographql.com";
      description = "GraphQL debugging tools for Apollo Client.";
      license = licenses.mit;
      mozPermissions = [
        "storage"
        "devtools"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "arcfox" = buildMozillaXpiAddon {
    pname = "arcfox";
    version = "2.5.3";
    addonId = "{8a65567e-d1bc-4494-a266-b3d300c106f8}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4352827/arcfox-2.5.3.xpi";
    sha256 = "b986cab8a396833872cae8124f03a63b568efc623f62a79a521a511c0dc32e45";
    meta = with lib; {
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
  "are-na" = buildMozillaXpiAddon {
    pname = "are-na";
    version = "2.12.1";
    addonId = "{4245110a-2f3e-4f78-8303-10cae12384cc}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4747739/are_na-2.12.1.xpi";
    sha256 = "dc98a3698bea675de9256b8673ce64ed4ffee12d02869689673cca2bc3a87059";
    meta = with lib; {
      homepage = "https://www.are.na";
      description = "Assemble and connect information.";
      license = licenses.mit;
      mozPermissions = [
        "activeTab"
        "contextMenus"
        "storage"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "bluesky-sidebar" = buildMozillaXpiAddon {
    pname = "bluesky-sidebar";
    version = "0.0.11";
    addonId = "{42f52678-fbed-4a73-88dd-b01f94d06cdb}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4560201/bluesky_sidebar-0.0.11.xpi";
    sha256 = "dfb24c072e2ffb12efd9da56bfc356a4df5862acd02c88c8b5e3a26466401601";
    meta = with lib; {
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
  "clicktabsort" = buildMozillaXpiAddon {
    pname = "clicktabsort";
    version = "3.2.1";
    addonId = "{9a51d52f-40fa-44c6-9c62-66936e43c4db}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3614940/clicktabsort-3.2.1.xpi";
    sha256 = "01ca403a8ea806bbe67f2a22222a00501659b1cc372b4b846b47ddd699f0353b";
    meta = with lib; {
      description = "Sort tabs from the right click menu.";
      license = licenses.mpl20;
      mozPermissions = [
        "contextMenus"
        "notifications"
        "storage"
        "tabs"
      ];
      platforms = platforms.all;
    };
  };
  "container-script" = buildMozillaXpiAddon {
    pname = "container-script";
    version = "1.3";
    addonId = "{fa0585bd-e256-4a38-ae72-a6f66d439644}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4742699/container_script-1.3.xpi";
    sha256 = "972d6906bce31d7c6e97c2ed385e37c565f5dbfaf63b5a9b944ee909213a538c";
    meta = with lib; {
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
  "enhanced-h264ify" = buildMozillaXpiAddon {
    pname = "enhanced-h264ify";
    version = "2.2.1";
    addonId = "{9a41dee2-b924-4161-a971-7fb35c053a4a}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4295701/enhanced_h264ify-2.2.1.xpi";
    sha256 = "68bf0cd6b2c26de24f263eb76848886665423b73c3f055633dcdbde51d2a35a9";
    meta = with lib; {
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
  "google-lighthouse" = buildMozillaXpiAddon {
    pname = "google-lighthouse";
    version = "100.0.0.3";
    addonId = "{cf3dba12-a848-4f68-8e2d-f9fadc0721de}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4148676/google_lighthouse-100.0.0.3.xpi";
    sha256 = "49cb8c94d536e1f49b76a3e75e8cd0c361961061da53039abbc5db755944afb9";
    meta = with lib; {
      homepage = "https://github.com/GoogleChrome/lighthouse";
      description = "Lighthouse is an open-source, automated tool for improving the performance, quality, and correctness of your web apps.";
      mozPermissions = [
        "activeTab"
        "storage"
      ];
      platforms = platforms.all;
    };
  };
  "let-s-get-color-blind" = buildMozillaXpiAddon {
    pname = "let-s-get-color-blind";
    version = "1.0.1resigned1";
    addonId = "letsgetcolorblind@hilberteikelboom.nl";
    url = "https://addons.mozilla.org/firefox/downloads/file/4273928/let_s_get_color_blind-1.0.1resigned1.xpi";
    sha256 = "aba501e26d25a147cc43418ea5306ebbe6e7ad342b630997027e5802db07f12b";
    meta = with lib; {
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
  "libraryextension" = buildMozillaXpiAddon {
    pname = "libraryextension";
    version = "2026.309.1";
    addonId = "firefox@libraryextension.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4718879/libraryextension-2026.309.1.xpi";
    sha256 = "10ae5c1c31e0bbdbaab4665fca2977fe7e91f8373f2c876f0a6068b1af00560a";
    meta = with lib; {
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
  "markdown-here" = buildMozillaXpiAddon {
    pname = "markdown-here";
    version = "2.16.0";
    addonId = "markdown-here-webext@adam.pritchard";
    url = "https://addons.mozilla.org/firefox/downloads/file/4530942/markdown_here-2.16.0.xpi";
    sha256 = "1009609bd560d71f8f35de86e288282e701ad003fc5a127f91e2fb3d23ea2e77";
    meta = with lib; {
      homepage = "https://github.com/adam-p/markdown-here";
      description = "Write your email in Markdown, then make it pretty.";
      license = licenses.mit;
      mozPermissions = [
        "activeTab"
        "contextMenus"
        "storage"
        "scripting"
      ];
      platforms = platforms.all;
    };
  };
  "mozeidon" = buildMozillaXpiAddon {
    pname = "mozeidon";
    version = "4.1";
    addonId = "mozeidon-addon@egovelox.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4760604/mozeidon-4.1.xpi";
    sha256 = "c490cab8ce45aeb98d4f3f304dad47c6bf4eecb6c069fcd849312bfdb1b8c76d";
    meta = with lib; {
      homepage = "https://github.com/egovelox/mozeidon";
      description = "Handle your tabs, groups, bookmarks and history from outside of your browser.\nThis native messaging add-on allows to interact with tabs, bookmarks, history.\n\nPlease read documentation on the github page ( see link below ).";
      license = licenses.mit;
      mozPermissions = [
        "nativeMessaging"
        "tabs"
        "sessions"
        "bookmarks"
        "history"
        "tabGroups"
        "storage"
      ];
      platforms = platforms.all;
    };
  };
  "okta-browser-plugin" = buildMozillaXpiAddon {
    pname = "okta-browser-plugin";
    version = "6.46.0";
    addonId = "plugin@okta.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4807793/okta_browser_plugin-6.46.0.xpi";
    sha256 = "007547000c9438c21f4ccd09ab447582be11d49c3b16b23ebfa03b2479cc8418";
    meta = with lib; {
      homepage = "https://www.okta.com";
      description = "Okta Browser Plugin";
      mozPermissions = [
        "tabs"
        "cookies"
        "https://*/"
        "http://*/"
        "storage"
        "unlimitedStorage"
        "webRequest"
        "webRequestBlocking"
        "webNavigation"
      ];
      platforms = platforms.all;
    };
  };
  "open-graph-preview-and-debug" = buildMozillaXpiAddon {
    pname = "open-graph-preview-and-debug";
    version = "1.0.4";
    addonId = "{6e262423-d612-4f29-be6e-e83aa641645d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4049194/open_graph_preview_and_debug-1.0.4.xpi";
    sha256 = "856c666a8999cfa91b0137aa8c22510de40f65a481e0fd2fd738bdc8752ac5e8";
    meta = with lib; {
      description = "Shows approximately what users will see if this webpage is shared on websites that uses OG tags to display a preview.\nLet you detect if no Open Graph Tags are set on your webpage !\nThe shown preview is inspired from the Facebook one.";
      license = licenses.mpl20;
      mozPermissions = [ "activeTab" ];
      platforms = platforms.all;
    };
  };
  "open-graph-previewer" = buildMozillaXpiAddon {
    pname = "open-graph-previewer";
    version = "1.0.1";
    addonId = "ruben.winant@hotmail.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4214314/open_graph_previewer-1.0.1.xpi";
    sha256 = "ad13a7f2880a9557f921c44615e338849d4dfe5024a20c1792fa6c694522fe00";
    meta = with lib; {
      homepage = "https://www.rubenwinant.be";
      description = "Preview how your website will look on social media with every Open Graph configuration, instantly.";
      license = licenses.mit;
      mozPermissions = [
        "tabs"
        "activeTab"
        "storage"
        "webNavigation"
        "devtools"
      ];
      platforms = platforms.all;
    };
  };
  "openlink-structured-data-sniff" = buildMozillaXpiAddon {
    pname = "openlink-structured-data-sniff";
    version = "3.4.27";
    addonId = "osds@openlinksw.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4558089/openlink_structured_data_sniff-3.4.27.xpi";
    sha256 = "2820efb3671bcf6e203088c0f01e17c1f3f39dc92d6b6b56a338070f19d8aead";
    meta = with lib; {
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
  "page-shadow" = buildMozillaXpiAddon {
    pname = "page-shadow";
    version = "2.11.5";
    addonId = "page-shadow@eliastiksofts.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4578914/page_shadow-2.11.5.xpi";
    sha256 = "7204d58d57bb732b1cd7aa75c22b848d731c07ddaf60a76631a8978510031b9a";
    meta = with lib; {
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
  "remove-paywall" = buildMozillaXpiAddon {
    pname = "remove-paywall";
    version = "1.1";
    addonId = "remove-paywall@example.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4428706/remove_paywall-1.1.xpi";
    sha256 = "89194a6425bc4dfe41031c534a8b995e596f0d370345e4c21b1c8263229b8061";
    meta = with lib; {
      description = "Remove paywalls from articles legally by searching public internet archives.";
      mozPermissions = [
        "activeTab"
        "contextMenus"
      ];
      platforms = platforms.all;
    };
  };
  "request-blocker-we" = buildMozillaXpiAddon {
    pname = "request-blocker-we";
    version = "0.6.2";
    addonId = "{8b0dd2c0-b9e8-46d5-b360-e2c53e43f2bc}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4193619/request_blocker_we-0.6.2.xpi";
    sha256 = "88a1bb807502c7fcc8f526b602298a8a71f9a44b85425f488e641afe1ef490e9";
    meta = with lib; {
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
  "rss-reader-extension-inoreader" = buildMozillaXpiAddon {
    pname = "rss-reader-extension-inoreader";
    version = "6.0.11";
    addonId = "inodhwnfgtr463428675drebcs@jetpack";
    url = "https://addons.mozilla.org/firefox/downloads/file/4754347/rss_reader_extension_inoreader-6.0.11.xpi";
    sha256 = "8e8d0a13628e045dad2637225df8891a54c3a43d05cb00647b0c3a9d435d5586";
    meta = with lib; {
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
  "winger" = buildMozillaXpiAddon {
    pname = "winger";
    version = "2.12.0";
    addonId = "winman@lionelw";
    url = "https://addons.mozilla.org/firefox/downloads/file/4706365/winger-2.12.0.xpi";
    sha256 = "55ede2b469de14c1673888623b0ae848b48bf62cadadb42fe215fe4645ccccc1";
    meta = with lib; {
      description = "Name windows, move tabs between windows, stash windows away, and more. Use multiple windows with ease, making them a truly viable way to organize lots of tabs.";
      license = licenses.mpl20;
      mozPermissions = [
        "alarms"
        "contextualIdentities"
        "cookies"
        "menus"
        "sessions"
        "storage"
        "tabs"
        "tabGroups"
      ];
      platforms = platforms.all;
    };
  };
  "youtube-addon" = buildMozillaXpiAddon {
    pname = "youtube-addon";
    version = "4.2026";
    addonId = "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4723468/youtube_addon-4.2026.xpi";
    sha256 = "fdd964bb8b157e1cc7983ea1b5ca4dab4fe56690098eb23ba0c4726381766535";
    meta = with lib; {
      homepage = "https://github.com/code4charity/YouTube-Extension/";
      description = "Youtube Extension. Powerful but lightweight. Enrich your Youtube and content selection. Make YouTube tidy and smart! (Layout, Filters, Shortcuts, Playlist)";
      mozPermissions = [
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "https://www.youtube.com/*"
      ];
      platforms = platforms.all;
    };
  };
  "zen-internet" = buildMozillaXpiAddon {
    pname = "zen-internet";
    version = "3.1.2";
    addonId = "{91aa3897-2634-4a8a-9092-279db23a7689}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4741120/zen_internet-3.1.2.xpi";
    sha256 = "79291e0da3ce9fea332a39993c62b1f71106cc5a062f82297bbd3f2d0c873a68";
    meta = with lib; {
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
