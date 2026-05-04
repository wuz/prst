{ inputs, ... }:
{
  conlin.direnv = {
    homeManager = {
      imports = [ inputs.direnv-instant.homeModules.direnv-instant ];
      programs.direnv-instant.enable = true;
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableBashIntegration = false;
        enableZshIntegration = true;
      };
    };
  };
}
