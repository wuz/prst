{ inputs, ... }:
{
  nodes.sops = {
    darwin =
      { lib, config, ... }:
      {
        imports = [ inputs.sops-nix.darwinModules.default ];

        # On darwin: use a dedicated age key file (bootstrapped on first activation).
        # Bootstrap: ssh-to-age -private-key -i ~/.ssh/id_ed25519 | sudo tee /var/lib/sops-nix/key.txt
        sops.age.keyFile = "/var/lib/sops-nix/key.txt";

        # Common secrets available on all hosts
        sops.secrets."github-access-token" = {
          sopsFile = ../../secrets/hosts/common.yaml;
          format = "yaml";
        };

        # nix.conf !include lines must be valid settings. A bare `github.com=…`
        # line is a syntax error; emit `access-tokens = …` instead.
        # The secret value must be whatever belongs after `access-tokens = `, e.g.
        # `github.com=github_pat_…` (one host=token pair). If you store only the
        # PAT, prefix it in sops as `github.com=<PAT>`.
        sops.templates."nix-github-access-tokens".content = ''
          access-tokens = ${config.sops.placeholder."github-access-token"}
        '';

        nix.extraOptions = lib.mkAfter ''
          !include ${config.sops.templates."nix-github-access-tokens".path}
        '';
      };

    nixos =
      { lib, config, ... }:
      {
        imports = [ inputs.sops-nix.nixosModules.default ];

        # On NixOS: derive the age key from the SSH host key automatically.
        sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

        # Common secrets available on all hosts
        sops.secrets."github-access-token" = {
          sopsFile = ../../secrets/hosts/common.yaml;
          format = "yaml";
        };

        sops.templates."nix-github-access-tokens".content = ''
          access-tokens = ${config.sops.placeholder."github-access-token"}
        '';

        nix.extraOptions = lib.mkAfter ''
          !include ${config.sops.templates."nix-github-access-tokens".path}
        '';
      };
  };
}
