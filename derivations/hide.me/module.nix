{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.hide-me;
  stateDir = "/var/lib/hide.me";
in
{
  options.services.hide-me = {
    enable = lib.mkEnableOption "hide.me VPN";
    server = lib.mkOption {
      type = lib.types.str;
      default = "nl";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "wireguard" ];

    systemd.services."hide-me@" = {
      description = "hide.me CLI connection to %i";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${cfg.package}/bin/hide-me --ca ${cfg.package}/share/hide.me/CA.pem connect %i";
        WorkingDirectory = stateDir;
        StateDirectory = "hide.me";
        StateDirectoryMode = "0700";

        ReadWritePaths = [
          stateDir
          "/etc"
        ]
        ++ lib.optional config.services.resolved.enable "-/run/systemd/resolve";
        TimeoutStopSec = 30;
        TimeoutStartSec = 120;
        Restart = "always";
        RestartSec = "5s";
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateTmp = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@module"
          "~@mount"
        ];
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        User = "root";
        Group = "root";
      };
    };

    systemd.targets.multi-user.wants = [ "hide-me@${cfg.server}.service" ];
  };
}
