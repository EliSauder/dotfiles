{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    enable = true;
    settings = {
      no_wrap = true;
      save_on_switch = true;
    };
  };
}
