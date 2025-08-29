{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./wallpaper.nix
    ./mako
    ./cliphist
    ./waybar
    ./hyprland
    ./wofi
    ./toolkits
    ./rofi
  ];
}
