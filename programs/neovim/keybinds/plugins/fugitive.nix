{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.nixvim.keymaps = [
    # -- Git fugative
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>Git<cr>";
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<cmd>Git log<cr>";
    }
    {
      mode = "n";
      key = "<leader>ga";
      action = "<cmd>Gwrite<cr>";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>Git commit<cr>";
    }
    {
      mode = "n";
      key = "<leader>gpl";
      action = "<cmd>Git pull<cr>";
    }
    {
      mode = "n";
      key = "<leader>gpu";
      action = "<cmd>15 split | term git push<cr>";
    }
    {
      mode = "n";
      key = "<leader>gf";
      action = "<cmd>Git fetch<cr>";
    }
    {
      mode = "n";
      key = "<leader>gbl";
      action = "<cmd>Git blame<cr>";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Telescope git_branches<cr>";
    }
    {
      mode = "n";
      key = "<leader>gbn";
      action.__raw = ''
        function()
          vim.ui.input({ prompt = "Enter a new branch name" }, 
            function(user_input)
              if user_input == nil or user_input == "" then
                return
              end

              local cmd_str = string.format("Git checkout -b %s", user_input)
              vim.cmd(cmd_str)
            end)
        end
      '';
    }
  ];

  programs.nixvim.autoCmd = [
    {
      event = "FileType";
      pattern = "fugitive";
      callback.__raw = ''
        function()
            vim.api.nvim_buf_set_keymap(0, 'n', '.', 'k',
                { noremap = true, silent = true })
        end
      '';
    }
  ];
}
