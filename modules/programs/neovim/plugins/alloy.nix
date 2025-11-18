{ pkgs, lib, ... }:
{
  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-alloy";
      src = pkgs.fetchFromGitHub {
        owner = "grafana";
        repo = "vim-alloy";
        rev = "0273f88f7199189f9a0f32213a34ab778e226f86";
        hash = lib.fakeHash;
      };
    })
  ];
}
