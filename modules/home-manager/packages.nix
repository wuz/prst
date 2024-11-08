{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs) nix-hash-unstable git-pull-status;

  python-with-global-packages = pkgs.python3.withPackages
    (ps: with ps; [ pip botocore setuptools pynvim fonttools brotli zopfli ]);

  optList = conditional: list: if conditional then list else [ ];
in {
  home.packages = with pkgs;
    lib.flatten [
      (optList stdenv.isDarwin [ reattach-to-user-namespace ])
      comma
      nix-prefetch-git
      fontforge
      fontforge-fonttools
      google-fonts
      python-with-global-packages
      darwin.trash
      eza
      jq
      bottom
      hyperfine
      du-dust
      procs
      fd
      figlet
      sd
      pup
      ranger
      time
      tokei
      tree
      unzip
      wget
      rename
      bandwhich
      grex
      ripgrep
      rsync
      tealdeer
      heroku
      melt
      git-town
      broot
      cloak
      vegeta
      w3m
      tree-sitter
      selene
      stylua
      luaformatter
      solargraph
      nodePackages.fixjson
      vscode
      # sniffnet
      # zed-editor
      scc
      openssh
      openssl
      libsecret
      dbus
      fastfetch
      btop
      lazydocker
      atac
      just
      nixd
      # GUI programs
      # davmail
      # wezterm
      /* fzf
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
      ollama
      lima
      onlykey-agent
      onlykey-cli
      # bash scripts
      nix-hash-unstable
      git-pull-status
    ];
}
