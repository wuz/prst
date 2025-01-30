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
      fonttools
      brotli
      zopfli
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
        iina
      ])

      fontforge
      fontforge-fonttools
      google-fonts
      python-with-global-packages
      tree-sitter
      scc
      openssh
      openssl
      libsecret
      dbus
      ollama
      fastfetch
      just
      fzf
      chafa
      jira-cli-go
      /*
        hadolint
        ipfs
        lolcat
        pkgsX86.luajit
        ninja
        nnn
        pkg-config
        pssh
        ssh-copy-id
        # thefuck
      */
      lima
      onlykey-agent
      onlykey-cli
      lapce

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
