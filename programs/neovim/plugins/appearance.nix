{pkgs, ...}: {
  programs.nixvim.plugins = {
    transparent.enable = true;
    mini = {
      enable = true;
      autoLoad = true;
      mockDevIcons = true;
      modules = {
        icons = {};
        statusline = {};
      };
    };
  };
}
