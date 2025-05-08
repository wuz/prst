{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cobiscripts = inputs.jacobi.packages.${pkgs.system};

  python-with-global-packages = pkgs.python3.withPackages (
    ps: with ps; [
      pip
      botocore
      setuptools
      pynvim
      brotli
      zopfli
      llm
    ]
  );

  optList = conditional: list: if conditional then list else [ ];
in
{
  home.packages =
    with pkgs;
    lib.flatten [
      (optList stdenv.isDarwin [
        reattach-to-user-namespace
        # iina
      ])

      scc

      fontforge
      fontforge-fonttools
      google-fonts

      python-with-global-packages

      openssh
      openssl
      libsecret
      dbus
      fastfetch
      just
      fzf
      chafa
      lima
      onlykey-agent
      onlykey-cli

      ollama

      lapce
      tree-sitter

      shellcheck
      shellharden
      shfmt
      go

      # jacobi
      cobiscripts.docker_pog_scripts
      cobiscripts.k8s_pog_scripts
      cobiscripts.nix_pog_scripts
    ];
}
