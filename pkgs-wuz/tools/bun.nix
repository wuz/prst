# { 
# pkgs,
# lib
# , name ? ""
# , stdenv
# , package ? pkgs.bun
# , cacert
# , nodejs-slim_22
# , nodePackages
# , inputs
# ,
# }:
# let
#   inherit (inputs) nix-filter;
#   hashes = {
#     "aarch64-darwin" = {
#       outputHash = "sha256-hWaad3tsqMe+3ps404MKa6ab60YuCkP2uCu8DHvE/vo=";
#     };
#     "x86_64-linux" = {
#       outputHash = "sha256-EBSkSuyClzvd4HIh/rKe3SXk5SpGA5wa0O04dIhqBQ4=";
#     };
#   };
#
#   bunDeps = stdenv.mkDerivation {
#     name = "${name}-bun-deps";
#     src = nix-filter.lib {
#       root = ../.;
#       exclude = [
#         ../.next
#         ../node_modules
#       ];
#     };
#     buildInputs = [ package ];
#     dontBuild = true;
#     dontConfigure = true;
#     dontFixup = true;
#     installPhase = ''
#       bun install --ignore-scripts --frozen-lockfile
#       cp -r ./node_modules $out
#     '';
#     outputHashAlgo = "sha256";
#     outputHashMode = "recursive";
#     outputHash = hashes.${stdenv.hostPlatform.system}.outputHash;
#     # outputHash = lib.fakeHash;
#   };
# in
# assert builtins.hasAttr stdenv.hostPlatform.system hashes;
# stdenv.mkDerivation {
#   NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
#   name = "${name}-frontend";
#   src = nix-filter.lib {
#     root = ../.;
#     exclude = [
#       ../.next
#       ../node_modules
#     ];
#   };
#
#   nativeBuildInputs = with pkgs; [
#     nodejs-slim_22
#     package
#     nodePackages.npm
#   ];
#
#   buildPhase = ''
#     runHook preBuild
#
#     cp -r ${bunDeps} ./node_modules
#     chmod -R +xw ./node_modules
#     patchShebangs ./node_modules
#     bun run build
#
#     runHook postBuild
#   '';
#
#   installPhase = ''
#     runHook preInstall
#
#     mkdir -p $out
#     patchShebangs ./.next
#     mv .next/standalone $out/bin
#     cp -R public $out/bin/public
#     mv .next/static $out/bin/.next/static
#     cat <<ENTRYPOINT > $out/bin/entrypoint
#     #!${stdenv.shell}
#     ${bun}/bin/bun $out/bin/server.js
#     ENTRYPOINT
#     chmod +x $out/bin/entrypoint
#
#     runHook postInstall
#   '';
#
#   meta.mainProgram = "entrypoint";
# }
