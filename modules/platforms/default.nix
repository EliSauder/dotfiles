{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./darwin.nix
    ./linux.nix
  ];
}
