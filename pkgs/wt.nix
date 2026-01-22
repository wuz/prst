{
  pkgs,
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "wt";
  version = "0.1.0";

  src = ./wt-src;

  pyproject = true;
  build-system = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    # Using only Python standard library
  ];

  meta = {
    description = "Git worktree workflow tool";
    license = lib.licenses.mit;
    mainProgram = "wt";
  };
}
