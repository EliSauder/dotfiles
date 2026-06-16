{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./uses
    ./platforms
    ./sops.nix
  ];

  xdg.configFile."nix/nix.conf".source = ./../config/nix/nix.conf;

  programs.fish.functions.homeupdate = "cd ${config.home.homeDirectory}/.dotfiles && nix flake update && git flake.lock && git commit -m 'chore: update flake.lock' && git push";

  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
