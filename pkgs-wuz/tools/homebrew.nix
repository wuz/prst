{
  pkgs,
  stdenv,
  lib,
}:
{
  appcleaner = stdenv.mkDerivation {
    name = "appcleaner";
    buildInputs = with pkgs; [ unzip ];
    src = pkgs.fetchzip {
      url = "https://www.freemacsoft.net/downloads/AppCleaner_3.6.8.zip";
      sha256 = "sha256-7csIo1W+br3SqOlflVuh0puoT0Qttr7c01i5OXibDGI=";
    };
    dontBuild = true;
    dontConfigure = true;
    installPhase = ''
      ls -al
      mv AppCleaner.app $out/
      ln -s $out/AppCleaner.app "$HOME/Applications/Home Manager Apps"
    '';
  };
}
