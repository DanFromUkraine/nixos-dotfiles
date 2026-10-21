{ }: {
  enable = true;

  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    minecraft = "gamescope -W 1920 -H 1200 --force-grab-cursor -- freesmlauncher";
  };

  oh-my-zsh = {
    enable = true;
    theme = "robbyrussell";

    plugins = [
      "git"
      "sudo"
    ];
  };
}
