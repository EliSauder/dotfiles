{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.ui.toolkits;
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
      pkgs.rose-pine-cursor
      #inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
    ];

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          application-prefer-dark-theme = 1;
        };

      };
    };

    gtk = lib.mkIf cfg.enableGtk {
      enable = true;
      theme.package = pkgs.layan-gtk-theme;
      theme.name = "Layan-Dark";
      iconTheme.package = pkgs.tela-icon-theme;
      iconTheme.name = "Tela";
      cursorTheme.package = pkgs.rose-pine-cursor;
      cursorTheme.name = "BreezeX-RosePine-Linux";

      gtk2.extraConfig = ''
        gtk-color-scheme "prefer-dark"
        color-scheme "prefer-dark"
      '';
      gtk3.extraConfig = {
        gtk-color-scheme = "prefer-dark";
        color-scheme = "prefer-dark";
        gtk-application-prefer-dark-theme = 1;
        application-prefer-dark-theme = 1;
      };
      gtk3.extraCss = ''
        :root {
          --prefers-color-scheme: dark;
        }
      '';
      gtk4.extraConfig = {
        gtk-color-scheme = "prefer-dark";
        color-scheme = "prefer-dark";
        gtk-application-prefer-dark-theme = 1;
        application-prefer-dark-theme = 1;
      };
      gtk4.extraCss = ''
        :root {
          --prefers-color-scheme: dark;
        }
      '';
    };

    home.sessionVariables = lib.mkIf cfg.enableGtk {
      GTK_USE_PORTAL = 1;
      GTK_THEME = "Layan-Dark:dark";
    };

    home.pointerCursor = {
      enable = true;
      dotIcons.enable = true;
      gtk = lib.mkIf cfg.enableGtk {
        enable = true;
      };
      name = "BreezeX-RosePine-Linux";
      #package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
      package = pkgs.rose-pine-cursor;
      hyprcursor = {
        size = 24;
        enable = true;
      };
      size = 24;
      x11 = {
        enable = true;
      };
    };

    qt = lib.mkIf cfg.enableQt {
      enable = true;
      platformTheme.name = "qt5ct";
      style = {
        package = pkgs.layan-kde;
        name = "Layan-Dark";
      };
    };
  };
}
