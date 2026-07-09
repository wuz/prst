{ inputs, ... }:
let
  mkOverlays =
    system:
    [
      inputs.nur.overlays.default
      inputs.neovim-nightly-overlay.overlays.default
      (import ../overlays)
      (_final: _prev: {
        bonsai = inputs.bonsai.packages.${system}.default;
      })
    ]
    ++ (if inputs.pog.overlays ? ${system} then [ inputs.pog.overlays.${system}.default ] else [ ]);
in
{
  # Systems to build for
  systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = mkOverlays system;
        config.allowUnfree = true;
      };
    };

  # Inject overlays into den host nixpkgs.
  # Use a module function that receives the host to get the system string.
  den.default = {
    nixos =
      { config, ... }:
      let
        system = config.nixpkgs.hostPlatform.system or "x86_64-linux";
      in
      {
        nixpkgs.overlays = mkOverlays system;
        nixpkgs.config.allowUnfree = true;
      };
    darwin =
      { config, ... }:
      let
        system = config.nixpkgs.hostPlatform.system or "aarch64-darwin";
      in
      {
        nixpkgs.overlays = mkOverlays system;
        nixpkgs.config.allowUnfree = true;
      };
  };
}
