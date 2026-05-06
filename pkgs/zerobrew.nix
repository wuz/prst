{
  pkgs,
  lib,
  rustPlatform,
  makeWrapper,
}:
rustPlatform.buildRustPackage {
  pname = "zerobrew";
  version = "2026-01-26";

  src = pkgs.fetchFromGitHub {
    owner = "lucasgelfond";
    repo = "zerobrew";
    rev = "e99a3b1f1a95f6fa68160e7e0d08032d532ec1de";
    hash = "sha256-XV1FWSNGAn/OS8475EGxSBcx1agyrZvwSnJj7WKK/iI=";
  };

  cargoHash = "sha256-iaLjhIUUKxV7fIiE3w9pFfeHcUUBVU15op0qESpKW3I=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/zb \
      --set-default XDG_DATA_HOME "$HOME/.local/share"
  '';

  meta = with lib; {
    description = "A faster, modern Mac package manager";
    homepage = "https://github.com/lucasgelfond/zerobrew";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.darwin;
  };
}
