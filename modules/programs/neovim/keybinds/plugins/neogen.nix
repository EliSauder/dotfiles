{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.keymaps = [
    # -- Neogen
    {
      mode = "n";
      key = "<leader>dc";
      action = ":lua require('neogen').generate({})<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];
}
