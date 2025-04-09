{pkgs, ...}: {
  programs.nixvim.plugins = {
    neogen = {enable = true;};

    undotree = {enable = true;};
    mini = {
      enable = true;
      autoLoad = true;
      mockDevIcons = true;
      modules = {
        surround = {}; # TODO: Learn keybinds
        splitjoin = {}; # TODO: Learn keybinds
        # TODO: Learn keybinds
        move = {
          mappings = {
            left = "";
            right = "";
            down = "";
            up = "";

            line_left = "";
            line_right = "";
            line_down = "";
            line_up = "";
          };
        };
        # clue = {};
      };
    };
  };
}
