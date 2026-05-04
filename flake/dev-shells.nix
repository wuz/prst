{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "prst";
        packages = with pkgs; [
          age
          just
          sops
          ssh-to-age
          nixd
          nixfmt-rfc-style
          statix
          deadnix
        ];
        shellHook = ''
          echo "prst dev shell"
        '';
      };
    };
}
