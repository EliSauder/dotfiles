{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim.keymaps = [
    # -- Move keybinds
    {
      mode = "n";
      key = "<";
      action = ":lua require('mini.move').move_line('up')<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = ">";
      action = ":lua require('mini.move').move_line('down')<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "M";
      action = ":lua require('mini.move').move_line('left')<cr>";
      options = {silent = true;};
    }
    {
      mode = "n";
      key = "?";
      action = ":lua require('mini.move').move_line('right')<cr>";
      options = {silent = true;};
    }

    {
      mode = "v";
      key = "<";
      action = ":lua require('mini.move').move_selection('up')<cr>";
      options = {silent = true;};
    }
    {
      mode = "v";
      key = ">";
      action = ":lua require('mini.move').move_selection('down')<cr>";
      options = {silent = true;};
    }
    {
      mode = "v";
      key = "M";
      action = ":lua require('mini.move').move_selection('left')<cr>";
      options = {silent = true;};
    }
    {
      mode = "v";
      key = "?";
      action = ":lua require('mini.move').move_selection('right')<cr>";
      options = {silent = true;};
    }
  ];
}
