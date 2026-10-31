{
  pkgs,
  ...
}:

{
  programs.vscode = {
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
  };

  #xdg.configFile."Code/User/chatLanguageModels.json" = {
    #force = true;
#
    #text = builtins.toJSON [
      #{
        #name = "Engy";
        #vendor = "customendpoint";
        #apiType = "chat-completions";
        #apiKey = "\${input:engyApiKey}";
        #models = [
          #{
            #id = "deepseek-v4.1-flash";
            #name = "DeepSeek V4.1 Flash";
            #url = "https://api.engy.ai/v1/chat/completions";
            #toolCalling = true;
            #vision = false;
            #thinking = true;
            #supportsReasoningEffort = [
              #"low"
              #"medium"
              #"high"
	      #"xhigh"
	      #""
            #];
            #reasoningEffortFormat = "chat-completions";
            #contextWindow = 1048576;
            #maxOutputTokens = 393216;
          #}
        #];
      #}
    #];
  # };
}
