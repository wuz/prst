{ inputs, ... }: {
  nodes.sops = {
    darwin = { lib, config, ... }: {
      imports = [ inputs.sops-nix.darwinModules.default ];

      # On darwin: use a dedicated age key file (bootstrapped on first activation).
      # Bootstrap: ssh-to-age -private-key -i ~/.ssh/id_ed25519 | sudo tee /var/lib/sops-nix/key.txt
      sops.age.keyFile = "/var/lib/sops-nix/key.txt";

      # Common secrets available on all hosts
      sops.secrets."github-access-token" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
      };

      sops.secrets."protonmail-bridge-password" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
        owner = "conlin.durbin";
      };

      sops.secrets."resolve-ai-token" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
        owner = "conlin.durbin";
      };

      sops.secrets."litellm-slack-api-key" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
        owner = "conlin.durbin";
      };

      sops.secrets."whatnot-inc-cachix-public-key" = {
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

      # OpenCode MCP API keys — exposed as session variables so opencode.jsonc
      # can reference them as $RESOLVE_AI_TOKEN and $LITELLM_SLACK_API_KEY.
      sops.templates."opencode-api-keys".content = ''
        RESOLVE_AI_TOKEN="Bearer ${config.sops.placeholder."resolve-ai-token"}"
        LITELLM_SLACK_API_KEY="Bearer ${config.sops.placeholder."litellm-slack-api-key"}"
      '';
      sops.templates."opencode-api-keys".owner = "conlin.durbin";

      # extra-* nix.conf settings append to (rather than replace) the
      # plaintext list set in nodes.nix, so the whatnot-inc cachix key
      # never needs to live unencrypted in the repo.
      sops.templates."nix-extra-trusted-public-keys".content = ''
        extra-trusted-public-keys = ${config.sops.placeholder."whatnot-inc-cachix-public-key"}
      '';

      nix.extraOptions = lib.mkAfter ''
        !include ${config.sops.templates."nix-github-access-tokens".path}
        !include ${config.sops.templates."nix-extra-trusted-public-keys".path}
      '';
    };

    nixos = { lib, config, ... }: {
      imports = [ inputs.sops-nix.nixosModules.default ];

      # On NixOS: derive the age key from the SSH host key automatically.
      sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      # Common secrets available on all hosts
      sops.secrets."github-access-token" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
      };

      sops.secrets."protonmail-bridge-password" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
      };

      sops.secrets."resolve-ai-token" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
      };

      sops.secrets."litellm-slack-api-key" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
      };

      sops.secrets."whatnot-inc-cachix-public-key" = {
        sopsFile = ../../secrets/hosts/common.yaml;
        format = "yaml";
      };

      sops.templates."nix-github-access-tokens".content = ''
        access-tokens = ${config.sops.placeholder."github-access-token"}
      '';

      sops.templates."opencode-api-keys".content = ''
        RESOLVE_AI_TOKEN="Bearer ${config.sops.placeholder."resolve-ai-token"}"
        LITELLM_SLACK_API_KEY="Bearer ${config.sops.placeholder."litellm-slack-api-key"}"
      '';

      sops.templates."nix-extra-trusted-public-keys".content = ''
        extra-trusted-public-keys = ${config.sops.placeholder."whatnot-inc-cachix-public-key"}
      '';

      nix.extraOptions = lib.mkAfter ''
        !include ${config.sops.templates."nix-github-access-tokens".path}
        !include ${config.sops.templates."nix-extra-trusted-public-keys".path}
      '';
    };
  };
}
