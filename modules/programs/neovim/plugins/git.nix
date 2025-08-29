{ pkgs, lib, ... }:
{
  programs.nixvim.plugins = {
    fugitive = {
      enable = true;
    };

    gitsigns = {
      enable = true;
      autoLoad = true;
      settings = {
        attach_to_untracked = true;
      };
    };
  };
}
