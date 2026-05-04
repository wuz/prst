{ ... }:
{
  nodes.shell = {
    os =
      { pkgs, ... }:
      {
        environment.shells = with pkgs; [
          bashInteractive
          zsh
        ];
        environment.systemPackages = with pkgs; [
          bashInteractive
          zsh
        ];
        programs.zsh.enable = true;
      };

    nixos = {
      environment.pathsToLink = [ "/share/bash-completion" ];
    };
  };
}
