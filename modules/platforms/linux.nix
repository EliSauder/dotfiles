{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.linux;
in
{
  imports = [
    ../programs
    ../ui
  ];

  options.platform = {
    linux.enable = lib.mkEnableOption "Enable development module";
    linux.useNvidia = lib.mkOption {
      default = false;
    };
    linux.commandPrefix = lib.mkOption {
      default = "";
    };
    linux.username = lib.mkOption {
      default = "emarusawa";
    };
    linux.homeDirectory = lib.mkOption {
      default = "/home/${cfg.username}";
    };
  };

  config = lib.mkIf cfg.enable {
    home.username = cfg.username;

    home.packages = [
      pkgs.xwayland
    ];

    home.homeDirectory = cfg.homeDirectory;

    home.sessionVariables.GTK_IM_MODULE = lib.mkForce "";

    prog.gsmartcontrol.enable = true;

    services.gnome-keyring.enable = true;

    prog.obs.enable = true;

    prog.nmtui.enable = true;

    ui.hyprland = {
      enable = true;
      commandPrefix = cfg.commandPrefix;
      terminal = {
        package = config.prog.ghostty.package;
        exeName = "ghostty";
      };
      browser = {
        package = config.prog.qutebrowser.package;
        exeName = "qutebrowser";
        launchWindowWithUrlArgs = [
          "--target window"
        ];
      };
      fileManager = {
        package = config.prog.dolphin.package;
        exeName = "dolphin";
      };
      useNvidia = cfg.useNvidia;
      keybinds = [
        "$mod, R, exec, uwsm app -- ${cfg.commandPrefix}${pkgs.remmina}/bin/remmina"
      ];
    };

    prog.dolphin = {
      enable = true;
      package = pkgs.kdePackages.dolphin;
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
        setSessionVariables = true;
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
