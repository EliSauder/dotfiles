{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.keymaps = {
    # -- Git fugative
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>Git<cr>";
    }
  };
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
