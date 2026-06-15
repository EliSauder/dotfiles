{ config, ... }:
{
  imports = [
    ./impl.nix
    ./qutebrowser-dev.nix
    ./catppuccin-startpage
    ./gst-plugin-spotify.nix
    ./dbeaver-with-drivers.nix
    ./waybar_now_playing.nix
    ./fonts
    ./nur.nix
    ./tmux-harpoon.nix
    ./rust-overlay.nix
    ./omnisharp
    ./nixgl.nix
  ];
}
