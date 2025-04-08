{
  config,
  pkgs,
  lib,
  ...
}: {
  import = [
    ./colemak.nix
    ./movements.nix
    ./utility.nix
    ./plugins
    ./lsp.nix
  ];
}
