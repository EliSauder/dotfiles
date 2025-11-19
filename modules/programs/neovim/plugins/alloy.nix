{ pkgs, lib, ... }:
let
  version = "8ef7871ea20646b5d00c530ec4a2d5ce8639e2ed";
in
{
  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-alloy";
      version = "0.1.3";
      src = pkgs.fetchFromGitHub rec {
        owner = "EliSauder";
        repo = "vim-alloy";
        rev = version;
        hash = "sha256-Au7IWGBFah300h7QLC4CzSUxsMNQgpncETSs8cJmISM="; # "sha256-lUOVfbdmEBuuIyxTFkWy7R3Sem6DnC6pjmu8XJWJYM8=";
      };
    })
  ];
}
