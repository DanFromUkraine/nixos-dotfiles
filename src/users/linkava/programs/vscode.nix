{ pkgs, ... }: {

  enable = true;

  package = pkgs.vscode.fhsWithPackages (
    ps: with ps; [
      python3
      platformio-core
      gcc
    ]
  );

  profiles.default.extensions = with pkgs.vscode-extensions; [
    esbenp.prettier-vscode
    platformio.platformio-vscode-ide
    jnoortheen.nix-ide
    ms-vscode-remote.remote-containers
  ];

}
