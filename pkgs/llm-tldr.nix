{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "llm-tldr";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "parcadei";
    repo = "llm-tldr";
    rev = "main";
    hash = "sha256-JPKz5oXtBzo7LP5HXRwUtOuGPuLCyhbUfAJOe0prMqQ=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    anthropic
    click
    faiss
    pathspec
    pygments
    rich
    sentence-transformers
    tiktoken
    tree-sitter
    watchdog
  ];

  # Disable runtime dependency check as some tree-sitter grammars may not be packaged
  dontCheckRuntimeDeps = true;

  # Skip import check - pygments_tldr and other dependencies may not be in nixpkgs
  pythonImportsCheck = [ ];

  meta = with lib; {
    description = "Extract code structure and dependencies for LLM consumption";
    homepage = "https://github.com/parcadei/llm-tldr";
    license = licenses.agpl3Only;
    maintainers = [ ];
    mainProgram = "tldr";
  };
}
