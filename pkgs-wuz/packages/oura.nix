{
  pkgs,
  stdenv,
  lib,
}:
stdenv.mkDerivation rec {
  name = "oura";
  version = "0.1.0";
  buildInputs = with pkgs; [ jq ];
  src = pkgs.fetchFromGitHub {
    owner = "arzzen";
    repo = "oura";
    rev = "master";
    sha256 = "sha256-ibtYuRv21s4T+PbV0o3jRAuG/6mlaLzwWhkEivL1sho=";
  };
  dontBuild = true;
  dontConfigure = true;
  installPhase = ''
    mkdir -p $out/bin/
    cp ./oura $out/bin/${name}
    chmod +x $out/bin/${name}
  '';
}
