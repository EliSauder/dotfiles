{ pkgs, ... }:
{
  programs.nixvim = {
    colorscheme = "catppuccin";

    colorschemes.catppuccin = {
      enable = true;
      lazyLoad.enable = true;
      settings = {
        term_colors = true;
        transparent_background = true;
        flavour = "mocha";
        integrations = {
          cmp = true;
          gitsigns = true;
          treesitter = true;
          fidget = true;
          harppon = true;
          mini.enabled = true;
          dap = true;
          semantic_tokens = true;
          nvim_surround = true;
          treesitter_context = true;
          telescope.enable = true;
          lsp_trouble = true;
        };
      };
      autoLoad = true;
    };
  };
}
