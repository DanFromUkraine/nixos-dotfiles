{
  enable = true;
  enableDefaultConfig = false;

  settings = {
    "gitlab.com" = {
      hostName = "gitlab.com";
      user = "git";
      identityFile = "~/nixos-config/src/secrets/gitlab/gitlab";
      identitiesOnly = true;
    };

    "github.com" = {
      hostName = "github.com";
      user = "git";
      identityFile = "~/nixos-config/src/secrets/github/github";
      identitiesOnly = true;
    };
  };
}
