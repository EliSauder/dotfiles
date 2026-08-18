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
          trigger.prefetch_on_insert = false;
          documentation.auto_show = true;
          ghost_text.enabled = true;
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
        #keymap.__raw = ''
        #  {
        #    ['<A-y>'] = require("minuet").make_blink_map(),
        #  }
        #'';
        sources = {
          default = [
            "lsp"
            "easy-dotnet"
            #"cursortab"
            "snippets"
            "buffer"
            "path"
            "vimwiki-tags"
            #"minuet"
          ];
          providers = {
            #cursortab = {
            #  module = "cursortab.blink";
            #  name = "cursortab";
            #  async = true;
            #  timeout_ms = 5000;
            #  score_offset = 50;
            #};
            #minuet = {
            #  name = "minuet";
            #  module = "minuet.blink";
            #  async = true;
            #  timeout_ms = 3000;
            #  score_offset = 50;
            #};
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
