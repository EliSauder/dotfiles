{
  config,
  pkgs,
  lib,
  pkgs-stable,
  ...
}:
let
  cfg = config.module.linux-general;
in
{
  imports = [
    ./programs
    ./ui
  ];

  options.module = {
    linux-general.enable = lib.mkEnableOption "Enable development module";
    linux-general.useNvidia = lib.mkOption {
      default = false;
    };
    linux-general.commandPrefix = lib.mkOption {
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.xwayland
    ];

    home.homeDirectory = "/home/esauder";

    home.sessionVariables.GTK_IM_MODULE = lib.mkForce "";

    services.gnome-keyring.enable = true;

    prog.obs.enable = true;

    ui.hyprland = {
      enable = true;
      commandPrefix = cfg.commandPrefix;
      terminal = "${config.prog.ghostty.package}/bin/ghostty";
      browser = "${pkgs.firefox}/bin/firefox";
      fileManager = "${config.prog.dolphin.package}/bin/dolphin";
      useNvidia = cfg.useNvidia;
      keybinds = [
        "$mod, R, exec, uwsm app -- ${cfg.commandPrefix}${pkgs.remmina}/bin/remmina"
      ];
    };

    prog.dolphin = {
      enable = true;
      package = pkgs-stable.kdePackages.dolphin;
      default = true;
    };

    ui.toolkits = {
      enable = true;
      enableGtk = true;
      enableQt = true;
    };

    xdg = {
      enable = true;
      autostart.enable = true;
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };
      userDirs = {
        enable = true;
        createDirectories = true;
      };
      mime.enable = true;
      mimeApps = {
        enable = true;
      };
    };

    systemd.user.enable = true;

    xsession.enable = true;

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-mozc
          catppuccin-fcitx5
        ];
      };
    };
  };
}
