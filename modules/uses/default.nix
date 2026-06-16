{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./general.nix
    ./development.nix
    ./personal.nix
    ./work.nix
  ];

}
