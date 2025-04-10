{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    #./colemak.nix
    ./movements.nix
    ./utility.nix
    ./plugins
    ./lsp.nix
  ];
}
