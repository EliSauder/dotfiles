{ config, ... }:
{
  imports = [
    ./waybar_now_playing.nix
    ./fonts
    ./nur.nix
    ./tmux-harpoon.nix
    ./ziggy.nix
  ];
}
