{ ... }:
{
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../../../configs/starship/starship.toml);
  };
}
