{ config, ... }:
{
  imports = [
    ./qutebrowser-dev.nix
    ./catppuccin-startpage
    ./gst-plugin-spotify.nix
    ./dbeaver-with-drivers.nix
    ./waybar_now_playing.nix
    ./fonts
    ./nur.nix
    ./tmux-harpoon.nix
    ./ziggy.nix
    ./rust-overlay.nix
    ./omnisharp
    ./nixgl.nix
    ./idrive.nix
  ];
}
