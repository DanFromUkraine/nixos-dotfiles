{
  enable = true;

  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    minecraft = "gamescope -W 1920 -H 1200 --force-grab-cursor -- freesmlauncher";
    pec = "sudo scxctl switch --sched scx_lavd --mode powersave";
    pfa = "sudo scxctl switch --sched scx_flash --args=\"-s 500 -l 40000 -I 0 -m performance\"";
    pbu = "sudo scxctl switch --sched scx_p2dq --args=\"--task-slice true --keep-running\"";
  };

  oh-my-zsh = {
    enable = true;
    theme = "robbyrussell";

    plugins = [
      "git"
      "sudo"
      "docker"
    ];
  };
}
