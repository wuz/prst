# spellbook — work MacBook
{ work, nodes, ... }: {
  den = {
    hosts.aarch64-darwin.spellbook.users."conlin.durbin" = { };

    aspects = {
      spellbook.includes = with nodes; [
        darwin-base
        duckypad
        karabiner
      ];

      # Work user: shared desktop bundle + work-specific overrides
      "conlin.durbin" = {
        includes = with work; [
          base
          desktop
          # zed
        ];

        homeManager = {
          programs.git.settings.user.email = "conlin.durbin@whatnot.com";
          programs.tiny.enable = true;
          programs.xplr.enable = true;
        };
      };
    };
  };
}
