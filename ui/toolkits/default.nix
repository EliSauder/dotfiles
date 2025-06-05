{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.ui.toolkits;
  rosePineCursor = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
in
{
  options.ui = {
    toolkits.enable = lib.mkEnableOption "Enable toolkit config";
    toolkits.enableGtk = lib.mkOption {
      default = true;
    };
    toolkits.enableQt = lib.mkOption {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.layan-gtk-theme
      pkgs.layan-kde
      pkgs.tela-icon-theme
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
    ];

    gtk = lib.mkIf cfg.enableGtk {
      enable = true;
      theme.package = pkgs.layan-gtk-theme;
      theme.name = "Layan-Dark";
      iconTheme.package = pkgs.tela-icon-theme;
      iconTheme.name = "Tela";
      cursorTheme.package = rosePineCursor;
      cursorTheme.name = "BreezeX-RosePine";
    };

    home.sessionVariables = lib.mkIf cfg.enableGtk {
      GTK_USE_PORTAL = 1;
    };

    home.pointerCursor = lib.mkIf cfg.enableGtk {
      gtk.enable = true;
      package = rosePineCursor;
      name = "BreezeX-RosePine";
      size = 24;
    };

    qt = lib.mkIf cfg.enableQt {
      enable = true;
      platformTheme.name = "kde";
      style = {
        package = pkgs.layan-kde;
        name = "Layan-Dark";
      };
    };
  };
}
