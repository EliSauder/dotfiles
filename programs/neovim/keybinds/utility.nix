{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.nixvim.keymaps = [
    # -- File viewer
    {
      mode = "n";
      key = "<leader>pv";
      action = "<cmd>Oil<cr>";
      options = {
        silent = true;
      };
    }
    # -- Center curosrs
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
    }

    {
      mode = "n";
      key = "n";
      action = "nzzzv";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
    }

    # -- Copy/Paste
    {
      mode = "x";
      key = "<leader>p";
      action = ''"_dP'';
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>y";
      action = ''"+y'';
    }
    {
      mode = "v";
      key = "<leader>Y";
      action = ''"+Y'';
    }

    # -- Format
    {
      mode = "n";
      key = "<leader>f";
      action.__raw = ''
        function()
            if vim.bo.filetype ~= "oil" then
                require('conform').format({ async = true, lsp_format = 'fallback' })
            end
        end
      '';
      options = {
        silent = true;
      };
    }
  ];
}
