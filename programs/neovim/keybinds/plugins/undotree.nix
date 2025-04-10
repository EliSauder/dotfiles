{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.keymaps = [
    # -- Undo tree
    {
      mode = "n";
      key = "<leader>u";
      action = "<cmd>UndotreeToggle<cr>";
    }
  ];
}
