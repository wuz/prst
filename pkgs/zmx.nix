{
  lib,
  stdenv,
  fetchurl,
}:
let
  version = "0.6.0";
  meta' = {
    homepage = "https://zmx.sh";
    description = "Session attach/detach for the terminal";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "zmx";
    platforms = lib.platforms.darwin;
  };

  srcs = {
    "aarch64-darwin" = {
      url = "https://zmx.sh/a/zmx-${version}-macos-aarch64.tar.gz";
      hash = "sha256-fx5Nln1B3qDfdrx8XdDVeV5+VP1lel8MdPv7LAaZOQ4=";
    };
    "x86_64-darwin" = {
      url = "https://zmx.sh/a/zmx-${version}-macos-x86_64.tar.gz";
      hash = lib.fakeHash; # update when needed
    };
  };
  src' =
    srcs.${stdenv.hostPlatform.system}
      or (throw "zmx: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "zmx";
  inherit version;

  src = fetchurl {
    url = src'.url;
    hash = src'.hash;
  };

  # tarball contains a single `zmx` binary at root
  unpackPhase = ''
    mkdir -p source
    tar -xzf $src -C source
  '';

  installPhase = ''
    install -Dm755 source/zmx $out/bin/zmx
  '';

  meta = meta';
}
