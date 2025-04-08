{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.keymaps = {
    # -- Harpoon
    {
      mode = "n";
      key = "<leader>a";
      action = ":lua require('harpoon'):list():add()<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-e>";
      action = ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-h>";
      action = ":lua require('harpoon'):list():select(1)<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-t>";
      action = ":lua require('harpoon'):list():select(2)<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-n>";
      action = ":lua require('harpoon'):list():select(3)<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "<C-s>";
      action = ":lua require('harpoon'):list():select(4)<cr>";
      options = {silent = true;};
    }
  };
}
