{ pkgs, ... }:
{
  home.packages = [
    pkgs.python313Packages.pylatexenc
  ];

  programs.nixvim.plugins = {
    transparent.enable = true;
    mini = {
      enable = true;
      autoLoad = true;
      mockDevIcons = true;
      modules = {
        icons = { };
        statusline = {
          use_icons = true;
        };
      };
    };

    render-markdown = {
      enable = true;
      settings = {
        completions.lsp.enable = true;
        render_modes = true;
        signs.enabled = true;
      };
    };
  };
}
