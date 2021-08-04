(self: super:
  (x: { hax = x; }) (with super;
    with lib;
    with builtins;
    lib // rec {
  tree-sitter-updated = super.tree-sitter.overrideAttrs(oldAttrs: {
    version = "0.17.3";
    sha256 = "sha256-uQs80r9cPX8Q46irJYv2FfvuppwonSS5HVClFujaP+U=";
    cargoSha256 = "sha256-fonlxLNh9KyEwCj7G5vxa7cM/DlcHNFbQpp0SwVQ3j4=";

    postInstall = ''
    PREFIX=$out make install
    '';

  });

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    name = "neovim-nightly";
    version = "0.5-nightly";
    src = self.fetchurl {
      url = "https://github.com/neovim/neovim/archive/master.zip";
      sha256 = "1r1384fqv84fk79kk5iqdxw2zq1h9sk72bx1d58kj7i6w5p67sms";
    };

    nativeBuildInputs = with self.pkgs; [ unzip cmake pkgconfig gettext tree-sitter-updated ];

  });
}))
