with builtins; [
  (self: super:
  (x: { hax = x; }) (with super;
  with lib;
  with builtins;
  lib // rec {
    inherit (stdenv) isLinux isDarwin;
    inherit (pkgs) fetchFromGitHub;
    mapAttrValues = f: mapAttrs (n: v: f v);
    fakePlatform = x:
    x.overrideAttrs (attrs: {
      meta = attrs.meta or { } // {
        platforms = stdenv.lib.platforms.all;
      };
    });
    prefixIf = b: x: y: if b then x + y else y;
    mapLines = f: s:
    concatMapStringsSep "\n" (l: if l != "" then f l else l)
    (splitString "\n" s);
    words = splitString " ";
    attrIf = check: name: if check then name else null;
    alias = name: x:
    writeShellScriptBin name
    ''exec ${if isDerivation x then exe x else x} "$@"'';
    overridePackage = pkg:
    let path = head (splitString ":" pkg.meta.position);
    in self.callPackage path;
    nix-direnv =
      self.overridePackage super.nix-direnv { nix = super.nixUnstable; };
      excludeLines = f: text:
      concatStringsSep "\n" (filter (x: !f x) (splitString "\n" text));
      drvs = x:
      if isDerivation x || isList x then
      flatten x
      else
      flatten (mapAttrsToList (_: v: drvs v) x);
      soundScript = x: y:
      writeShellScriptBin x ''
      ${sox}/bin/play --no-show-progress ${y}
      '';
      drvsExcept = x: e:
      with { excludeNames = concatMap attrNames (attrValues e); };
      flatten (drvs (filterAttrsRecursive (n: _: !elem n excludeNames) x));
      dmgOverride = name: pkg:
      with rec {
        src = sources."dmg-${name}";
        msg = "${name}: src ${src.version} != pkg ${pkg.version}";
        checkVersion = lib.assertMsg (pkg.version == src.version) msg;
      };
      if isDarwin then
      assert checkVersion;
      (mkDmgPackage name src) // {
        originalPackage = pkg;
      }
      else
      pkg;
    }))
    (self: super:
    with super;
    mapAttrs (n: v: hax.fakePlatform v) { inherit gixy; })
    (self: super:
    with super;
    with hax;
    (fn:
    optionalAttrs (pathExists ./pkgs)
    (listToAttrs (mapAttrsToList fn (readDir ./pkgs)))) (n: _: rec {
      name = removeSuffix ".nix" n;
      value = pkgs.callPackage (./pkgs + ("/" + n)) { };
    }))
    (self: super: {

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
          sha256 = "0g3a2j07n1jmf34rj63rh4fakrgjlnw3094g6cibp5gm0bzv98gz";
        };

        nativeBuildInputs = with self.pkgs; [ unzip cmake pkgconfig gettext tree-sitter-updated ];

      });

    })
  ]


