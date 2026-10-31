{
  enable = true;
  enableDefaultConfig = false;

  settings = {
    "gitlab.com" = {
      hostName = "gitlab.com";
      user = "git";
      identityFile = "~/nixos-config/secrets/gitlab/gitlab";
      identitiesOnly = true;
    };

    "github.com" = {
      hostName = "github.com";
      user = "git";
      identityFile = "~/nixos-config/secrets/github/github";
      identitiesOnly = true;
    };
  };
}
