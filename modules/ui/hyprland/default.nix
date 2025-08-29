{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprland.nix
  ];
}
