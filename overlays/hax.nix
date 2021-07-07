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
          meta = attrs.meta or { } // { platforms = stdenv.lib.platforms.all; };
        });
      prefixIf = b: x: y: if b then x + y else y;
      mapLines = f: s:
        concatMapStringsSep "\n" (l: if l != "" then f l else l)
        (splitString "\n" s);
      words = splitString " ";
      attrIf = check: name: if check then name else null;
      getJson = url: sha256:
        let
          text = fetchurl {
            url = url;
            sha256 = sha256;
          };
        in fromJSON (readFile text);
      mkImpureDrv = name: path:
        runCommandLocal "${name}-impure-darwin" {
          __impureHostDeps = [ path ];

          meta = { platforms = lib.platforms.darwin; };
        } ''
          if ! [ -x ${path} ]; then
            echo Cannot find command ${path}
            exit 1
          fi
          mkdir -p $out/bin
          ln -s ${path} $out/bin
          manpage="/usr/share/man/man1/${name}.1"
          if [ -f $manpage ]; then
            mkdir -p $out/share/man/man1
            ln -s $manpage $out/share/man/man1
          fi
        '';
      installer = mkImpureDrv "installer" "/usr/sbin/installer";
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
