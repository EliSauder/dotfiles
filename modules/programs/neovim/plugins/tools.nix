{ pkgs, ... }:
{

  home.packages = [
    pkgs.gh
  ];
  programs.nixvim.plugins = {
    snacks = {
      enable = true;
      settings = {
        bigfile.enable = true;
        dashboard = {
          enable = true;
          example = "github";
        };
        gh.enable = true;
        dim.enable = true;
        animate.enable = true;
        git.enable = true;
        image.enable = true;
        indent.enable = true;
        notifier.enable = true;
        scope.enable = true;
        statuscolumn.enable = true;
      };
    };

    neogen = {
      enable = true;
    };

    undotree = {
      enable = true;
    };

    git-conflict = {
      enable = true;
    };

    mini = {
      enable = true;
      autoLoad = true;
      mockDevIcons = true;
      modules = {
        surround = { }; # TODO: Learn keybinds
        splitjoin = { }; # TODO: Learn keybinds
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
