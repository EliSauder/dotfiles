{ config, lib, pkgs, inputs, ... }:
{

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.homeDirectory = if pkgs.stdenv.isLinux then "/home/esauder" else "/Users/esauder";
  home.username = "esauder";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
    "discord"
    "obsidian"
    "perfecto-calligraphy-pu-ttf"
    "shelley-allegro-bt-otf"
    "reaper"
  ];

  imports = [
    ./programs
    #./ui
  ];

    prog.steam.enable = true;
    prog.discord.enable = true;
    prog.floorp.enable = true;
    prog.git.enable = true;
    prog.inkscape.enable = true;
    prog.libreoffice.enable = true;
    prog.obs.enable = true;
    prog.obsidian.enable = true;
    prog.reaper.enable = true;
    prog.spacedrive.enable = true;
    prog.ssh.enable = true;
    prog.wezterm.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.xivlauncher

    pkgs.jq
  ];

  home.sessionVariables = {
    EDITOR = "${pkgs.nvim}/bin/nvim";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #programs._1password.enable = true;
  #programs._1password-gui = {
  #  enable = true;
  #  polkitPolicyOwners = [ "esauder" ];
  #};

}
