{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules;
in
{
  imports = [
    ./uses
    ./platforms
    ./sops.nix
  ];

  options.modules = {
    enable = lib.mkEnableOption "Enable development module";
    uses = lib.mkOption {
      default = [ ];
    };
    username = lib.mkOption {
      default = "emarusawa";
    };
    commandPrefix = lib.mkOption {
      default = "";
    };
  };

  config =
    let
      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      stateVersion = "24.05"; # Please read the comment before changing.
    in
    {

      home.stateVersion = stateVersion; # Please read the comment before changing.
    }
    // (lib.mkIf cfg.enable {
      xdg.configFile."nix/nix.conf".source = ./../config/nix/nix.conf;

      programs.fish.functions.homeupdate = "cd ${config.home.homeDirectory}/.dotfiles && nix flake update && git add flake.lock && git commit -m 'chore: update flake.lock' && git push";

      programs.home-manager.enable = true;

      home.stateVersion = stateVersion;

      module.general = {
        enable = true;
        username = cfg.username;
        commandPrefix = cfg.commandPrefix;
        uses = cfg.uses;
      };

      module.work = lib.mkIf (builtins.elem "work" cfg.uses) {
        enable = true;
      };

      module.personal = lib.mkIf (builtins.elem "personal" cfg.uses) {
        enable = true;
        commandPrefix = cfg.commandPrefix;
      };

      module.development = lib.mkIf (builtins.elem "development" cfg.uses) {
        enable = true;
        enableDotnet7 = if (builtins.elem "work" cfg.uses) then true else false;
      };
    });
}
