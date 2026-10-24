{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };

  provider = "engy";
  model = "deepseek-v4.1-flash";
  visionModel = "qwen3.8-27b";

  visionConfig = {
    inherit provider;
    model = visionModel;
    enabled = true;
    maxDimension = 1568;
    jpegQuality = 85;
    defaultReasoningEffort = "off";
    cacheEnabled = true;
    cachePersist = true;
    cacheMaxEntries = 256;
    markerStyle = "code";
    textOnlyPasteMode = "hint";
    composePreview = true;
    batchConcurrency = 5;
    auditLog = true;
    localOnly = false;
    autoDetectVisionModel = false;
  };

  ruleMap =
    pairs:
    "{\n"
    + lib.concatStringsSep ",\n" (
      map (p: "    ${builtins.toJSON (builtins.elemAt p 0)}: ${builtins.toJSON (builtins.elemAt p 1)}") pairs
    )
    + "\n  }";

  pathRules = [
    [ "*" "allow" ]
    [ "*.env" "deny" ]
    [ "*.env.*" "deny" ]
    [ "*.env.example" "allow" ]
  ];

  bashRules = [
    [ "*" "allow" ]
    [ "sudo *" "ask" ]
    [ "doas *" "ask" ]
    [ "pkexec *" "ask" ]
    [ "su *" "deny" ]

    [ "rm *" "deny" ]
    [ "rmdir *" "deny" ]
    [ "unlink *" "deny" ]
    [ "shred *" "deny" ]
    [ "truncate *" "deny" ]

    [ "dd *" "deny" ]
    [ "mkfs*" "deny" ]
    [ "fdisk *" "deny" ]
    [ "parted *" "deny" ]
    [ "wipefs *" "deny" ]
    [ "blkdiscard *" "deny" ]
    [ "mount *" "deny" ]
    [ "umount *" "deny" ]
    [ "swapoff *" "deny" ]

    [ "chown *" "deny" ]
    [ "chgrp *" "deny" ]
    [ "chmod *" "deny" ]
    [ "chattr *" "deny" ]
    [ "setfacl *" "deny" ]

    [ "git reset --hard*" "deny" ]
    [ "git clean *" "deny" ]
    [ "git push --force*" "deny" ]
    [ "git push -f*" "deny" ]
    [ "git branch -D*" "deny" ]
    [ "git checkout -- *" "deny" ]
    [ "git restore *" "deny" ]
    [ "git stash drop*" "deny" ]
    [ "git stash clear*" "deny" ]
    [ "git filter-branch*" "deny" ]
    [ "git reflog expire*" "deny" ]

    [ "nix-collect-garbage *" "deny" ]
    [ "nix store delete*" "deny" ]
    [ "nix store gc*" "deny" ]
    [ "nix profile remove*" "deny" ]
    [ "nix-env -e*" "deny" ]

    [ "reboot*" "deny" ]
    [ "poweroff*" "deny" ]
    [ "halt*" "deny" ]
    [ "shutdown *" "deny" ]

    [ "passwd*" "deny" ]
    [ "userdel *" "deny" ]
    [ "groupdel *" "deny" ]
    [ "crontab -r*" "deny" ]
    [ "history -c*" "deny" ]

    [ "killall *" "deny" ]
    [ "kill *" "ask" ]
    [ "pkill *" "ask" ]
    [ "systemctl poweroff*" "deny" ]
    [ "systemctl reboot*" "deny" ]

    [ "mv *" "ask" ]
    [ "cp *" "ask" ]
    [ "tee *" "ask" ]

    [ "find *" "allow" ]
    [ "find * -delete*" "deny" ]
    [ "find * -fprint*" "deny" ]
    [ "find * -fls*" "deny" ]
    [ "find * -exec*" "ask" ]
    [ "find * -ok*" "ask" ]

    [ "sed *" "ask" ]
    [ "sed -n '*p' *" "allow" ]  
    [ "sed -n \"*p\" *" "allow" ]
    [ "sed -n '*p'" "allow" ]   
    [ "sed -n \"*p\"" "allow" ]
    [ "sed '*p' *" "allow" ]   
    [ "sed \"*p\" *" "allow" ]
    [ "sed 's/*' *" "allow" ] 
    [ "sed \"s/*\" *" "allow" ]
    [ "sed -E 's/*' *" "allow" ]
    [ "sed -e 's/*' *" "allow" ]

    [ "awk *" "ask" ]
    [ "awk '{print*}' *" "allow" ]
    [ "awk \"{print*}\" *" "allow" ]
    [ "awk -F* '{print*}' *" "allow" ]
    [ "awk -F * '{print*}' *" "allow" ]

    [ "sort *" "ask" ]
    [ "fd *" "ask" ]
  ];

  permissionJson = ''
    {
      "permission": {
        "*": "allow",
        "path": ${ruleMap pathRules},
        "bash": ${ruleMap bashRules},
        "external_directory": "ask",
        "external_directory_read": { "*": "allow" }
      }
    }
  '';
in
{
  programs.pi-coding-agent = {
    enable = true;
    extraPackages = with pkgs; [ nodejs ];

    settings = {
      defaultProvider = provider;
      defaultModel = model;
      defaultThinkingLevel = "high";

      packages = [
        "npm:pi-web-access@0.44.0"
        "npm:@forecastx/deep-research@0.1.1"
        "npm:@gotgenes/pi-permission-system@41.0.0"
        "npm:pi-powerline-footer@0.20.2"
        "npm:@getpipher/vision@0.5.3"
      ];
    };

    models.providers.${provider} = {
      baseUrl = "https://api.engy.ai/v1";
      api = "openai-completions";

      apiKey = "!cat ~/nixos-config/src/secrets/apis/engy";

      compat = {
        supportsDeveloperRole = false;
        supportsReasoningEffort = true;
        thinkingFormat = "openai";
      };

      models = [
        {
          id = model;
          name = "DeepSeek V4.1 Flash";
          reasoning = true;
          contextWindow = 1000000;
          maxTokens = 16384;
          thinkingLevelMap = {
            minimal = "low";
            low = "low";
            medium = "high";
            high = "high";
            xhigh = "xhigh";
            max = "max";
          };
        }
        {
          id = visionModel;
          name = "Qwen3.8 27B (vision)";
          reasoning = false;
          input = [
            "text"
            "image"
          ];
          contextWindow = 1001536;
          maxTokens = 16384;
        }
      ];
    };
  };

  home.file = {
    "${cfg.configDir}/settings.json".force = true;

    "${cfg.configDir}/vision.json" = {
      source = jsonFormat.generate "pi-vision.json" visionConfig;
      force = true;
    };

    "${cfg.configDir}/extensions/pi-permission-system/config.json" = {
      text = permissionJson;
      force = true;
    };
  };
}
