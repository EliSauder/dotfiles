{ pkgs, lib, ... }:
{

  home.packages = [
    pkgs.gh
  ];

  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "excel.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "HimadriChakra12";
        repo = "excel.nvim";
        rev = "fc529b9cc18c4edf988749aa3238d1cb156f7720";
        hash = "sha256-9hRM34JQpFjoPDBbW59Cs6w8gwsr/Lsi0HDjx+mozXA=";
      };
      buildInputs = [
        pkgs.libreoffice
      ];
    })
  ];
  programs.nixvim.extraPackages = [
    pkgs.libreoffice
  ];
  programs.nixvim.extraConfigLua =
    let
      py = pkgs.python3.withPackages (ps: [
        ps.pandas
        ps.openpyxl
        ps.xlrd
      ]);
    in
    ''
      require("excel").setup({
        max_col_width = 20,
        min_col_width = 8,
        show_gridlines = true,
        auto_recalc = true,

        python_cmd = "${py}/bin/python3",
      })
    '';
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
