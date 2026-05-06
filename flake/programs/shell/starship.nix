{ ... }:
{
  prst.starship = {
    homeManager = {
      programs.starship = {
        enable = true;
        settings = fromTOML (builtins.readFile ../../../configs/starship/starship.toml);
      };
    };
  };
}
