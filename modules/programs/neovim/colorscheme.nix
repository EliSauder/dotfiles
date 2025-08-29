{ pkgs, ... }:
{
  programs.nixvim = {
    colorscheme = "catppuccin";

    colorschemes.catppuccin = {
      enable = true;
      lazyLoad.enable = true;
      settings = {
        color_overrides = {
          all = {
            base = "#000000";
            mantle = "#000000";
            crust = "#000000";
          };
        };
        term_colors = true;
        transparent_background = false;
        flavour = "mocha";
        background = {
          dark = "mocha";
        };
        float = {
          transparent = true;
        };
        dim_inactive = {
          enabled = true;
        };
        auto_integrations = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          treesitter = true;
          fidget = true;
          notify = true;
          harppon = true;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
          blink_cmp = {
            style = "bordered";
          };
          markdown = true;
          markview = true;
          render_markdown = true;
          dap = true;
          dap_ui = true;
          semantic_tokens = true;
          nvim_surround = true;
          rainbow_delimiters = true;
          treesitter_context = true;
          telescope = {
            enable = true;
          };
          lsp_trouble = true;
          noice = true;
          copilot = true;
          dadbod_ui = true;
        };
      };
      autoLoad = true;

      luaConfig.post = ''
        local sign = vim.fn.sign_define

        sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
        sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
        sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})
      '';
    };
  };
}
