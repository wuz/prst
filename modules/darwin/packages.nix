{
  user,
  lib,
  pkgs,
  ...
}:
let
  optList = conditional: list: if conditional then list else [ ];

  python-with-global-packages = pkgs.python3.withPackages (
    ps: with ps; [
      pip
      botocore
      setuptools
      pynvim
      brotli
      zopfli
    ]
  );
in
{
  environment.systemPackages =
    with pkgs;
    lib.flatten [
      (optList stdenv.isDarwin [
        reattach-to-user-namespace
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
      fzf
      lima
      onlykey-agent
      onlykey-cli

      shellcheck
      shellharden
      shfmt
      go

      gcc
      curl
      gnugrep
      gnupg
      gnused
      gawk
      msgpack
      libiconvReal
      coreutils-full
      findutils
      diffutils
      moreutils
      libuv
      gnupg
      zsh
      pinentry_mac
      nur.repos.rycee.mozilla-addons-to-nix
      just

      lapce
      ollama
      chafa
    ];
}
