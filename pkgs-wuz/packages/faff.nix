{
  pkgs,
  stdenv,
  lib,
}:
stdenv.mkDerivation rec {
  name = "faff";
  version = "0.1.0";
  buildInputs = with pkgs; [ unzip ];
  src = pkgs.fetchurl {
    url = "https://github.com/wimpysworld/faff/archive/refs/tags/${version}.zip";
    sha256 = "sha256-d9baQQb5Wg1mXEkiXM4j2t2EpXWQf+hfcLlndk+7ZVE=";
    # sha256 = lib.fakeSha256;
  };
  dontBuild = true;
  dontConfigure = true;
  # dontUnpack = true;
  installPhase = ''
    cp ./faff.sh >> $out/bin/faff
    cat $textPath >> $out/bin/${name}
    chmod +x $out/bin/${name}
    ${pkgs.shellcheck}/bin/shellcheck $out/bin/${name}
  '';
}
