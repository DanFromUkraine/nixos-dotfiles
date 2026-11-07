{
  config,
  pkgs,
  ...
}:
{
  programs.pi-coding-agent = {
    enable = true;
    extraPackages = with pkgs; [ nodejs ];

    settings = {
      defaultProvider = "engy";
      defaultModel = "deepseek-v4.1-flash";
      defaultThinkingLevel = "high";

      packages = [
        "npm:pi-web-access@0.44.0"
        "npm:@forecastx/deep-research@0.1.1"
        "npm:pi-cyber-ui"
        "npm:pi-subagents"
        "npm:pi-nvim"
      ];
    };

    models.providers.engy = {
      baseUrl = "https://api.engy.ai/v1";
      api = "openai-completions";

      apiKey = "!cat ~/nixos-config/secrets/apis/engy";

      compat = {
        supportsDeveloperRole = false;
        supportsReasoningEffort = true;
        thinkingFormat = "openai";
      };

      models = [
        {
          id = "deepseek-v4.1-flash";
          name = "DeepSeek V4.1 Flash";
          reasoning = true;
          contextWindow = 1048576;
          maxTokens = 393216;
          input = [
            "text"
            "image"
          ];
          thinkingLevelMap = {
            minimal = "low";
            low = "low";
            medium = "high";
            high = "high";
            xhigh = "xhigh";
            max = "max";
          };
        }
      ];
    };
  };

  home.file = {
    "${config.programs.pi-coding-agent.configDir}/settings.json".force = true;
  };

  home.file.".pi/agent/AGENTS.md".source = ./assets/baseAgentsInstructions.md;
  home.file.".pi/agent/prompts/o.md".source = ./assets/orchestrationPromptTemplate.md;
  home.file.".pi/agent/prompts/f.md".source = ./assets/fastModePromptTemplate.md;
}
