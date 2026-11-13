{
  config,
  ...
}:
let
  engyKey = "${config.home.homeDirectory}/nixos-config/secrets/apis/engy";
in
{
  programs.opencode = {
    enable = true;

    settings = {
      "$schema" = "https://opencode.ai/config.json";

      model = "engy/deepseek-v4.1-flash";

      agents.chat = {
        description = "ChatGPT-like chat: no local access, web only";
        mode = "primary";
        model = "engy/deepseek-v4.1-flash#none";
        steps = 6;

        system = ''
          You are a general-purpose chat assistant.
          Answer directly and concisely, like a chat product.
          You have NO access to the user's files, shell, or computer.
          You may use web search/fetch only when current information is genuinely needed.
          Do not describe plans, steps, or tool strategy. Just answer.
        '';

        permissions = [
          {
            action = "*";
            resource = "*";
            effect = "deny";
          } 
          {
            action = "webfetch";
            resource = "*";
            effect = "allow";
          }
          {
            action = "websearch";
            resource = "*";
            effect = "allow";
          }
          {
            action = "question";
            resource = "*";
            effect = "allow";
          }
        ];
      };

      providers.engy = {
        name = "engy";
        package = "@opencode/ai/providers/openai-compatible";
        settings = {
          baseURL = "https://api.engy.ai/v1";
          apiKey = "{file:${engyKey}}";
        };
        models = {
          "deepseek-v4.1-flash" = {
            name = "DeepSeek V4.1 Flash";
            limit = {
              context = 1048576;
              output = 393216;
            };
            capabilities = {
              tools = true;
              input = [
                "text"
                "image"
              ];
              output = [ "text" ];
              reasoning = {
                supported = true;
                effort = [
                  "none"
                  "low"
                  "high"
                  "xhigh"
                  "max"
                ];
              };
            };
          };
        };
      };

      plugins = [
        {
          package = "@heretek-ai/opencode-searxng";
          options = {
            baseUrl = "http://127.0.0.1:2202";
            categories = "general";
            language = "all";
            safesearch = 0;
            maxResults = 8;
            timeoutMs = 30000;
          };
        }
      ];
      websearch.provider = "searxng";
    };

    commands = {
      o = ./assets/orchestrationPromptTemplate.md;
      f = ./assets/fastModePromptTemplate.md;
    };
  };

  home.file."opencode/AGENTS.md".source = ./assets/baseAgentsInstructions.md;
}
