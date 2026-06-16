{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./development.nix
    ./personal.nix
    ./work.nix
  ];

}
