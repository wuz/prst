# conceptually this is a great idea, but it doesn't quite work for m1 macs
{ config, ... }:

{
  homebrew = {
    enable = false;
    autoUpdate = true;
    cleanup = "zap";

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "wez/wezterm"
    ];

    brews = [ "pam-u2f" ];

    casks = [
      "insomnia"
      "alfred"
      "monitorcontrol"
      "ubersicht"
      "cleanshot"
      "muzzle"
      "owncloud"
      "waterfox"
      "google-chrome"
      "brave-browser"
      "itsycal"
      "notion"
      "obsidian"
      "appcleaner"
      "yubico-yubikey-manager"
      "bitwarden"
      "1password"
      "ipfs"
      "mullvadvpn"

      "affinity-designer"
      "affinity-photo"

      "visual-studio-code"
      "keybase"
      "bartender"
      "tunnelblick"
      "rectangle"
      "karabiner-elements"
      "iterm2-nightly"
      "wezterm"

      "steam"
      "discord"
      "slack"
      "signal"
      "pulse-sms"

      "audio-hijack"
      "spotify"
      "beardedspice"

      "radicle-upstream"
    ];

    masApps = {
      Pages = 409201541;
      WebcamSettings = 533696630;
      Contrast = 1254981365;
      NextMeeting = 1017470484;
      Displays = 1107272470;
    };

    extraConfig = "";
  };

  system.activationScripts.extraUserActivation.text = ''
    ${config.system.activationScripts.homebrew.text}
  '';

}
