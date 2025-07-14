{ config, ... }:
{
  imports = [
    ./dbeaver-with-drivers.nix
    ./waybar_now_playing.nix
    ./fonts
    ./nur.nix
    ./tmux-harpoon.nix
    ./ziggy.nix
    ./rust-overlay.nix
    ./omnisharp
  ];
}
