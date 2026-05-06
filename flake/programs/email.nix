{ ... }:
{
  work.email = {
    homeManager =
      { config, ... }:
      {
        programs.himalaya = {
          enable = true;
          settings = {
            downloads-dir = "${config.home.homeDirectory}/Downloads";
          };
        };
      };
  };
}
