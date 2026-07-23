# grimoire — personal MacBook
{
  personal,
  work,
  nodes,
  ...
}:
{
  den = {
    hosts.aarch64-darwin.grimoire.users."wuz" = { };

    aspects = {
      grimoire.includes = with nodes; [ darwin-base ];

      # Personal user: same desktop bundle, personal identity
      wuz = {
        includes = [
          personal.base
          work.desktop
          work.zed
        ];

        homeManager = {
          programs.git.settings.user.email = "c@wuz.sh";
        };
      };
    };
  };
}
