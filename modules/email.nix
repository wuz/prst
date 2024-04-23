{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs) fetchFromGithub;
  inherit (pkgs.stdenv) isDarwin;
in {
  home-manager.users."conlin.durbin = {
    programs.mbsync = { enable = true; };
    programs.offlineimap.enable = true;
    programs.msmtp.enable = true;
    programs.notmuch = {
      enable = true;
      hooks = { preNew = "mbsync --all"; };
    };

    xdg.configFile.".config/neomutt" = {
      recursive = true;
      source = ../config/neomutt;
      target = "neomutt/";
    };
    programs.neomutt = {
      enable = true;
      vimKeys = true;
      binds = [
        {
          action = "sidebar-toggle-visible";
          key = "<left>";
          map = [ "index" "pager" ];
        }
        {
          action = "sidebar-toggle-visible";
          key = "b";
          map = [ "index" "pager" ];
        }
        {
          action = "sidebar-next";
          key = "<down>";
          map = [ "index" "pager" ];
        }
        {
          action = "sidebar-prev";
          key = "<up>";
          map = [ "index" "pager" ];
        }
        {
          action = "sidebar-open";
          key = "<right>";
          map = [ "index" "pager" ];
        }
      ];
      sort = "reverse-threads";
      sidebar = {
        enable = true;
        format = "%B %?N?(%N)?%*";
      };
      editor = "nvim";
      extraConfig = ''
        source ~/.config/neomutt/colors.mutt
      '';
    };
    accounts.email = {
      # notmuch
      # neomutt
      # zathura
      # feh
      accounts.work = {
        address = "conlin.durbin@payscale.com";
        userName = "conlin.durbin@payscale.com";
        passwordCommand =
          "security find-generic-password -a conlin.durbin@payscale.com -l email -w";
        # flavor = "outlook.office365.com";
        imap = {
          host = "localhost";
          port = 1143;
          tls = { enable = false; };
        };
        smtp = {
          host = "localhost";
          port = 1025;
          tls = { enable = false; };
        };
        offlineimap = {
          enable = true;
          postSyncHookCommand = "notmuch new";
          extraConfig.account = { autorefresh = 20; };
        };
        mbsync = {
          enable = true;
          create = "imap";
          extraConfig = { account = { AuthMechs = "LOGIN"; }; };
        };
        msmtp = {
          enable = true;
          extraConfig = {
            auth = "login";
            tls = "off";
          };
        };
        notmuch.enable = true;
        neomutt = {
          enable = true;
          extraConfig = "";
        };
        primary = true;
        realName = "Conlin Durbin";
        signature = {
          text = "";
          showSignature = "none";
        };
      };

    };
  };
}

