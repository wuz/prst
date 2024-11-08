{ ... }: {
  launchd.user.envVariables = {
    MOZ_LEGACY_PROFILES = "1";
    MOZ_ALLOW_DOWNGRADE = "1";
  };
}
