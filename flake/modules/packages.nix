{ inputs, ... }:
{
  nodes.packages = {
    os =
      { lib, pkgs, ... }:
      let
        cobiscripts = inputs.jacobi.packages.${pkgs.stdenv.hostPlatform.system};
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
        nixpkgs.config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "python3.13-ecdsa-0.19.1"
          ];
        };

        environment.systemPackages =
          with pkgs;
          lib.flatten [
            # Core system utils
            coreutils-full
            curl
            diffutils
            findutils
            fzf
            gawk
            gcc
            gnugrep
            gnupg
            gnused
            moreutils
            openssh
            openssl
            zsh

            # Dev tooling
            go
            python-with-global-packages
            uv
            tree-sitter

            # Nix ecosystem
            just
            sops
            ssh-to-age
            nur.repos.rycee.mozilla-addons-to-nix

            # Apps / services
            dstp
            flyctl
            opencode

            # Fonts / design
            fontforge
            fontforge-fonttools
            google-fonts

            # K8s / infra
            kubernetes-helm

            # Hardware
            onlykey-agent
            onlykey-cli

            # Utilities
            chafa
            desed
            difftastic
            fastfetch
            ffmpeg
            imagemagick
            kdlfmt
            lazyworktree
            libiconvReal
            markdownlint-cli2
            mergiraf
            nix-search-cli
            scc
            shellcheck
            shellharden
            shfmt
            srgn

            # Darwin-only
            (lib.optional stdenv.isDarwin reattach-to-user-namespace)
            (lib.optional stdenv.isDarwin pinentry_mac)

            # cobiscripts
            cobiscripts.docker_pog_scripts
            cobiscripts.k8s_pog_scripts
            cobiscripts.nix_pog_scripts
          ];
      };

    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          bash-completion
          bashInteractive
          dbus
          libsecret
          libuv
          msgpack-c
          msgpack-cxx
        ];
      };
  };
}
