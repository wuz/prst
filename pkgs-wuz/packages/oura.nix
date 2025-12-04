{
  pkgs,
  stdenv,
  lib,
}:
stdenv.mkDerivation rec {
  name = "oura";
  version = "0.0.0";
  buildInputs = with pkgs; [ jq ];
  src = pkgs.fetchFromGitHub {
    owner = "arzzen";
    repo = "oura";
    rev = "master";
    sha256 = lib.fakeSha256;
  };
  # dontBuild = true;
  # dontConfigure = true;
  installPhase = ''
    mkdir -p $out/bin/
    ls
    cat readme.md
    cp ./oura $out/bin/${name}
    chmod +x $out/bin/${name}
  '';
}
