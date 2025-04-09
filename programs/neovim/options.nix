{pkgs, ...}: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      transparent_enabled = true;

      editorconfig = {
        enable = true;
        properties = {
          charset = "utf-8";
          end_of_line = "lf";
          indent_style = "space";
          indent_size = 4;
          insert_final_newline = true;
          tab_width = 4;
          trailing_whitespace = true;
        };
      };
    };

    opts = {
      number = true;
      relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      expandtab = true;

      autoindent = true;
      smartindent = true;
      shiftwidth = 4;

      swapfile = false;
      backup = false;
      undodir = "${config.xdg.dataHome}/nvim/undodir";
      undofile = true;

      hlsearch = false;
      incsearch = true;
      ignorecase = true;
      smartcase = true;

      termguicolors = true;
      background = "dark";

      encoding = "utf-8";
      fileencoding = "utf-8";

      scrolloff = 8;
      signcolumn = "yes";
      # isfname = config.programs.nixvim.opts.isfname ++ "@-@";

      updatetime = 50;

      colorcolumn = "80";
      cursorline = true;
      cursorcolumn = false;

      foldlevel = 99;
    };

    extraConfigLua = ''
      vim.highlight.priorities.semantic_tokens = 95
    '';
  };
}
