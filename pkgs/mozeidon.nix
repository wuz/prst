{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mozeidon";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "egovelox";
    repo = "mozeidon";
    rev = "v${version}";
    hash = "sha256-bnd2fa8PIYNjR3fam1cCsuf4+4ZImHdDwN1qHyvOjlk=";
  };

  sourceRoot = "source/cli";

  vendorHash = "sha256-dz9QN4eDiLLCjLXB2tDMrp0vrdB8Gbc/lJOH8Yz6exY=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/egovelox/mozeidon";
    description = "CLI to handle Firefox or Chrome tabs, history and bookmarks";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mozeidon";
  };
}
