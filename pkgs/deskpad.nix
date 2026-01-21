{
  pkgs,
  stdenv,
  lib,
}:
stdenv.mkDerivation rec {
  name = "deskpad";
  version = "1.3.2";
  buildInputs = with pkgs; [ unzip ];
  src = pkgs.fetchzip {
    url = "https://github.com/Stengo/DeskPad/releases/download/v${version}/DeskPad.app.zip";
    sha256 = "sha256-eFKRbMFmEQ1MC8oNSXyTTt5Xwdpv9Tp+7eVsH4qFHQk=";
    stripRoot = false;
    # sha256 = lib.fakeSha256;
  };
  dontBuild = true;
  dontConfigure = true;
  # dontUnpack = true;
  installPhase = ''
    mkdir -p $out/Applications
    mv DeskPad.app $out/Applications
  '';
}
