{ config, pkgs, lib, ... }: {
    imports = [
        ./discord
        ./firefox
        ./floorp
        ./git
        ./inkscape
        ./kitty
        ./libreoffice
        ./nemo
        ./neovim
        ./obs
        ./obsidian
        ./reaper
        ./spacedrive
        ./ssh
        ./wezterm
        ./steam
    ];
}
