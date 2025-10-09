{
  pkgs,
  config,
  lib,
  ...
}:
let
  mailHome = "${config.xdg.dataHome}/mail";
in
{
  accounts.email.accounts = {
    ic-personal = rec {
      realName = "Conlin Durbin";
      address = "conlin@infinite-citadel.com";
    };
    ic-general = rec {
      realName = "Infinite Citadel";
      address = "info@infinite-citadel.com";
      himalaya = {
        inherit (config.programs.himalaya) enable;
        settings = {
          backend = {
            type = "imap";
            host = "imap.forwardemail.net";
            port = 993;
            login = address;
            auth.type = "password";
            auth.command = "security find-internet-password -s 'icgeneral' -w";
          };
          message = {
            delete.style = "folder";
            send.backend = {
              type = "smtp";
              host = "smtp.forwardemail.net";
              port = 465;
              login = address;
              auth.type = "password";
              auth.command = "security find-internet-password -s 'icgeneral' -w";
            };
          };
        };
      };
    };
    protonmail = rec {
      realName = "Conlin Durbin";
      primary = true;
      address = "conlind@proton.me";
      himalaya = {
        inherit (config.programs.himalaya) enable;
        settings = {
          default = true;
          backend = {
            type = "imap";
            host = "127.0.0.1";
            port = 1143;
            login = address;
            encryption.type = "none";
            auth.type = "password";
            auth.command = "security find-internet-password -s 'protonmail' -w";
          };
          message = {
            delete.style = "folder";
            send.backend = {
              type = "smtp";
              host = "127.0.0.1";
              port = 1025;
              encryption.type = "none";
              login = address;
              auth.type = "password";
              auth.command = "security find-internet-password -s 'protonmail' -w";
            };
          };
        };
      };
    };
  };
}
