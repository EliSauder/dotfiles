{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;

      settings = {
        completion.accept.auto_brackets.semantic_token_resolution.enabled = true;
        signature.enabled = true;
        completion = {
          documentation.auto_show = true;
          accept.auto_brackets = {
            enabled = true;
            blocked_filetypes = [ ];
            default_brackets = [
              "("
              ")"
            ];
          };
        };
        sources = {
          default = [
            "lsp"
            "easy-dotnet"
            "snippets"
            "buffer"
            "path"
          ];
          providers = {
            dadbod.module = "vim_dadbod_completion.blink";
            easy-dotnet = {
              name = "easy-dotnet";
              module = "easy-dotnet.completion.blink";
              score_offset = 10000;
              async = true;
            };
          };

          per_filetype = {
            sql = [ "dadbod" ];
          };
        };
      };
    };
  };
}
