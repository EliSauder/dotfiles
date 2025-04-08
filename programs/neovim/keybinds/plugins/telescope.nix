{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.keymaps = {
    # -- Telescope
    {
      mode = "n";
      key = "<leader>pf";
      action = ":lua require('telescope.builtin').find_files()<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<leader>ps";
      action = ":lua require('telescope.builtin').live_grep()<cr>";
      options = {silent = true;};
    }
  };
}
