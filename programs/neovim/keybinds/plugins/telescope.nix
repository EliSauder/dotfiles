{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    pkgs.ripgrep
  ];

  programs.nixvim.keymaps = [
    # -- Telescope
    {
      mode = "n";
      key = "<leader>pf";
      action = ":lua require('telescope.builtin').find_files()<cr>";
      options = {
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ps";
      action = ":lua require('telescope.builtin').live_grep()<cr>";
      options = {
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gws";
      action = ":lua require('telescope').extensions.git_worktree.git_worktree()<cr>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<leader>gwn";
      action = ":lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>";
      options.silent = true;
    }
  ];
}
