{ pkgs }: {
  enable = true;
  extraPackages = with pkgs; [ nodejs ];

  settings = {
    defaultProvider = "engy";
    defaultModel = "deepseek-v4.1-flash";
    defaultThinkingLevel = "high";

    packages = [
      "npm:pi-web-access@0.44.0"
      "npm:@forecastx/deep-research@0.1.1"
      "npm:@gotgenes/pi-permission-system@41.0.0"
      "npm:pi-powerline-footer@0.20.2"
    ];
  };

  models.providers.engy = {
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
        id = "deepseek-v4.1-flash";
        name = "DeepSeek V4.1 Flash";
        reasoning = true;
        contextWindow = 1000000;
        maxTokens = 16384;
      }
    ];
  };
}
