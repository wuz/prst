with builtins; 
(self: super: {

  tree-sitter-updated = super.tree-sitter.overrideAttrs(oldAttrs: {
    version = "0.17.3";
    sha256 = "sha256-uQs80r9cPX8Q46irJYv2FfvuppwonSS5HVClFujaP+U=";
    cargoSha256 = "sha256-fonlxLNh9KyEwCj7G5vxa7cM/DlcHNFbQpp0SwVQ3j4=";

    postInstall = ''
    PREFIX=$out make install
    '';

  });

  waterfox = super.callPackage ../packages/waterfox.nix {};

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    name = "neovim-nightly";
    version = "0.5-nightly";
    src = self.fetchurl {
      url = "https://github.com/neovim/neovim/archive/master.zip";
      sha256 = "0g3a2j07n1jmf34rj63rh4fakrgjlnw3094g6cibp5gm0bzv98gz";
    };

    nativeBuildInputs = with self.pkgs; [ unzip cmake pkgconfig gettext tree-sitter-updated ];

  });

})



