{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./mako
    ./cliphist
    ./waybar
    ./hyprland
    ./wofi
    ./toolkits
    ./rofi
  ];
}
