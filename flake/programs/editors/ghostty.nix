{ ... }:
{
  conlin.ghostty = {
    homeManager =
      { config, ... }:
      {
        programs.ghostty = {
          enable = false; # ghostty on nixpkgs darwin is currently broken
          enableZshIntegration = true;
        };
        xdg.configFile."ghostty" = {
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink ../../../configs/ghostty;
        };
      };
  };
}
