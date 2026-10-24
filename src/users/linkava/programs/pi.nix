{
  config,
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

  permissionConfig = {
    permission = {
      "*" = "allow";
      path = {
        "*" = "allow";
        "*.env" = "deny";
        "*.env.*" = "deny";
        "*.env.example" = "allow";
      };
      bash = {
        "*" = "ask";
        "rm -rf *" = "deny";
        "sudo *" = "ask";
      };
      external_directory = "ask";
    };
  };
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

    "${cfg.configDir}/extensions/pi-permission-system/config.json".source =
      jsonFormat.generate "pi-permissions.json" permissionConfig;
  };
}
