{
  pkgs,
  stdenv,
  lib,
}:
stdenv.mkDerivation rec {
  name = "ccmenu";
  version = "26.0";
  buildInputs = with pkgs; [ unzip ];
  src = pkgs.fetchzip {
    url = "https://github.com/ccmenu/ccmenu2/releases/download/v${version}/CCMenu.zip";
    sha256 = "sha256-Xmls6fiN4fz1Ttw6P8dcQ3SS1FTFRRxBTdBWqq941xc=";
    stripRoot = false;
    # sha256 = lib.fakeSha256;
  };
  dontBuild = true;
  dontConfigure = true;
  # dontUnpack = true;
  installPhase = ''
    mkdir -p $out/Applications
    mv CCMenu.app $out/Applications
  '';
}
