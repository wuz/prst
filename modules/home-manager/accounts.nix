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
    ic-personal = {
      address = "conlin@infinite-citadel.com";
    };
    ic-general = {
      address = "info@infinite-citadel.com";
      folders = {
        inbox = "inbox";
        sent = "sent";
        drafts = "drafts";
        trash = "bin";
      };
      himalaya = {
        inherit (config.programs.himalaya) enable;
        settings = {
          backend = {
            type = "maildir";
            root-dir = "${mailHome}/ic-general";
          };
          message = {
            delete.style = "folder";
            send.backend = {
              type = "sendmail";
              cmd = "msmtp --read-envelope-from --read-recipients";
            };
          };
        };
      };
    };
    protonmail = {
      address = "conlind@proton.me";
    };
  };
}
