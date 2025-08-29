{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./ui
    ./programs
  ];
}
