{ pkgs ? import <nixpkgs> { } }:
let
  native_libs = with pkgs;
    [ libffi zlib ncurses gmp pkgconfig ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Cocoa CoreServices ]);
in pkgs.stdenv.mkDerivation rec {
  pname = "sumneko-lua-language-server";
  version = "1.21.3";

  src = pkgs.fetchFromGitHub {
    owner = "sumneko";
    repo = "lua-language-server";
    rev = "49ed110bca2ee7d39311f1a973792748ad138437";
    sha256 = "0z5zm8sl4hvbhw7bz7apfkcmcm0gzg5hxdjwdyhx83il0sjk7in5";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with pkgs; [ ninja makeWrapper ] ++ native_libs;

  preBuild = ''
    cd 3rd/luamake
  '';

  ninjaFlags = [ "-vvv" "-f compile/ninja/macos.ninja" ];

  postBuild = ''
    cd ../..
    ./3rd/luamake/luamake rebuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/extras
    ls ./bin/macOS
    runHook postInstall
  '';
}

# cp -r ./{locale,meta,script,*.lua} $out/extras/
# cp ./bin/macOS/{bee.so,lpeglabel.so} $out/extras
# cp ./bin/macOS/lua-language-server $out/extras/.lua-language-server-unwrapped
# makeWrapper $out/extras/.lua-language-server-unwrapped \
#   $out/bin/lua-language-server \
#   --add-flags "-E $out/extras/main.lua \
#   --logpath='~/.cache/sumneko_lua/log' \
#   --metapath='~/.cache/sumneko_lua/meta'"
