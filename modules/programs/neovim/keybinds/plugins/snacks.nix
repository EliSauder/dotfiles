{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.nixvim.keymaps = [
    # -- Undo tree
    {
      mode = "n";
      key = "<leader>nh";
      action = ":lua require('snacks').notifier.show_history()";
    }
  ];
}
