{ stdenv, fetchurl, undmg, lib }:

stdenv.mkDerivation rec {
  pname = "Waterfox";
  version = "G3.2.1";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
      mkdir -p "$out/Applications"
      cp -r Waterfox.app "$out/Applications/Waterfox.app"
    '';

  src = fetchurl {
    name = "Waterfox-${version}.dmg";
    url = "https://cdn.waterfox.net/releases/osx64/installer/Waterfox%20${version}%20Setup.dmg";
    sha256 = "0if4lhzdi6srjsdl0k4mp21ysni1az5lc3p21zjnbs6ih38x3shr";
  };

  meta = with lib; {
    description = "The Waterfox web browser";
    homepage = "https://www.waterfox.net/";
    maintainers = [ maintainers.wuz ];
    platforms = platforms.darwin;
  };
}
