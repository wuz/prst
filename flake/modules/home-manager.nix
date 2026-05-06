{ inputs, lib, ... }:
{
  # Mark all users as homeManager class users.
  # den's built-in home-manager.nix (in den/modules/aspects/provides/) auto-detects
  # this and wires ctx.host → ctx.hm-host → ctx.hm-user pipeline to create
  # home-manager.users.<userName> entries.
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # Configure shared HM settings applied to all hosts.
  den.ctx.hm-host.includes = [
    (
      { host, ... }:
      {
        ${host.class}.home-manager = {
          backupFileExtension = "bak";
          useGlobalPkgs = true;
          useUserPackages = true;
          verbose = true;
          extraSpecialArgs = { inherit inputs; };
        };
      }
    )
  ];
}
