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
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      (pkgs.catppuccin-kvantum.override {
        accent = "teal";
        variant = "mocha";
      })
      pkgs.catppuccin-kde
      pkgs.kdePackages.qtstyleplugin-kvantum
      pkgs.kdePackages.qt6ct
      pkgs.kdePackages.qt5compat
      pkgs.kdePackages.qt6gtk2
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
      qutebrowser.enable = true;
      kvantum.enable = false;
      fish.enable = false;
      gtk = {
        icon.enable = true;
      };
      hyprland.enable = true;
      hyprlock.enable = true;
      k9s.enable = true;
      librewolf.enable = true;
      mako.enable = true;
      mpv.enable = true;
      nvim.enable = false;
      obs.enable = true;
      rofi.enable = true;
      spotify-player.enable = true;
      thunderbird.enable = true;
      tmux.enable = false;
      waybar.enable = true;
    };

    gtk =
      let
        themePkg = pkgs.catppuccin-gtk.override {
          accents = [ "teal" ];
          variant = "mocha";
        };
        themeNm = "catppuccin-mocha-teal-standard";
      in
      lib.mkIf cfg.enableGtk {
        enable = true;
        theme.package = themePkg;
        theme.name = themeNm;
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
        gtk4.theme = {
          package = themePkg;
          name = themeNm;
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
      #package = inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
      platformTheme.name = "qtct";
    };

    xdg.configFile = lib.mkIf cfg.enableQt {
      "Kvantum/catppuccin-mocha-teal".source =
        "${pkgs.catppuccin-kvantum}/share/Kvantum/catppuccin-mocha-teal";
      "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
        General.theme = "catppuccin-mocha-teal";
      };
    };
  };
}
