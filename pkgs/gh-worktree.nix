{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gh-worktree";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "eikster-dk";
    repo = "gh-worktree";
    rev = "v${version}";
    hash = "sha256-OU5y7wIuuKKW+5TiQktALEJ0mnEeSZQAs39IVPz1e+Y=";
  };

  vendorHash = "sha256-NRa4sfT5SIyPDm6HG4gHamYIh0Lky9D7y7oaKs8UJbQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Disable tests as they may require network access or git setup
  doCheck = false;

  meta = {
    homepage = "https://github.com/eikster-dk/gh-worktree";
    description = "GitHub CLI extension for managing git worktrees";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gh-worktree";
  };
}
