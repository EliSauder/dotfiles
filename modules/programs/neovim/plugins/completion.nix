{ ... }:
{
  programs.nixvim.plugins = {
    blink-compat = {
      enable = true;
      settings = {
        impersonate_nvim_cmp = true;
      };
    };

    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;

      settings = {
        signature.enabled = true;
        completion = {
          documentation.auto_show = true;
          accept.auto_brackets = {
            enabled = true;
            semantic_token_resolution.enabled = true;
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
            "vimwiki-tags"
          ];
          providers = {
            dadbod.module = "vim_dadbod_completion.blink";
            easy-dotnet = {
              name = "easy-dotnet";
              module = "easy-dotnet.completion.blink";
              score_offset = 10000;
              async = true;
            };
            vimwiki-tags = {
              name = "vimwiki-tags";
              module = "blink.compat.source";
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
