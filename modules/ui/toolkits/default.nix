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
      pkgs.rose-pine-cursor
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
      (pkgs.catppuccin-kvantum.override {
        accent = "teal";
        variant = "mocha";
      })
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.libsForQt5.qt5ct
      pkgs.kdePackages.qtstyleplugin-kvantum
    ];

    dconf = lib.mkIf cfg.enableGtk {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          application-prefer-dark-theme = 1;
        };

      };
    };

    catppuccin = {
      enable = true;
      accent = "teal";
      flavor = "mocha";
      btop.enable = true;
      fcitx5 = {
        enable = true;
        apply = true;
        enableRounded = true;
      };
      firefox = {
        enable = true;
        force = true;
      };
      fish.enable = true;
      gtk = {
        icon.enable = true;
      };
      hyprland.enable = true;
      hyprlock.enable = true;
      k9s.enable = true;
      kvantum.enable = true;
      librewolf.enable = true;
      mako.enable = true;
      mpv.enable = true;
      nvim.enable = true;
      obs.enable = true;
      rofi.enable = true;
      spotify-player.enable = true;
      thunderbird.enable = true;
      tmux.enable = true;
      waybar.enable = true;
    };

    gtk = lib.mkIf cfg.enableGtk {
      enable = true;
      theme.package = (
        pkgs.catppuccin-gtk.override {
          accents = [ "teal" ];
          variant = "mocha";
        }
      );
      theme.name = "catppuccin-mocha-teal-standard";
      cursorTheme.package = pkgs.rose-pine-cursor;
      cursorTheme.name = "BreezeX-RosePine-Linux";

      gtk2.extraConfig = ''
        gtk-color-scheme "prefer-dark"
      '';
      #  color-scheme "prefer-dark"
      #  '';
      gtk3.extraConfig = {
        gtk-color-scheme = "prefer-dark";
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-color-scheme = "prefer-dark";
        gtk-application-prefer-dark-theme = 1;
      };
    };

    home.sessionVariables = lib.mkIf cfg.enableGtk {
      GTK_USE_PORTAL = 1;
      GTK_THEME = "catppuccin-mocha-teal:dark";
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
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };

    #xdg.configFile = lib.mkIf cfg.enableQt {
    #  "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
    #    General.theme = "Catppuccin-Mocha-Teal";
    #  };
    #};
  };
}
