{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./darwin-general.nix
    ./linux-general.nix
    ./development.nix
    ./play.nix
    ./shared.nix
  ];
}
