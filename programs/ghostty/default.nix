{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.ghostty;
  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;

  settings = {
    theme = "catppuccin-mocha";
    command = startupscript;
    background = "000000";
    background-opacity = 0.8;
    background-blur = true;
  };
  themes = {
    catppuccin-mocha-manual = {
      background = "000000";
      cursor-color = "f5e0dc";
      cursor-text = "1e1e2e";
      foreground = "cdd6f4";
      palette = [
        "0=#45475a"
        "1=#f38ba8"
        "2=#a6e3a1"
        "3=#f9e2af"
        "4=#89b4fa"
        "5=#f5c2e7"
        "6=#94e2d5"
        "7=#a6adc8"
        "8=#585b70"
        "9=#f38ba8"
        "10=#a6e3a1"
        "11=#f9e2af"
        "12=#89b4fa"
        "13=#f5c2e7"
        "14=#94e2d5"
        "15=#bac2de"
      ];
      selection-background = "353749";
      selection-foreground = "cdd6f4";
    };
  };

  startupscript = "${pkgs.writeShellScriptBin "start.sh" ''
    #!/bin/sh

    ${pkgs.fish}/bin/fish -i -l -c 'exec ${pkgs.sesh}/bin/sesh connect default'
  ''}/bin/start.sh";
in
{
  options.prog = {
    ghostty.enable = lib.mkEnableOption "Enable ghostty";
    ghostty.package = lib.mkPackageOption pkgs "ghostty" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-color-emoji
      pkgs.iosevka
      pkgs.nerd-fonts.fira-code
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.fira-go
      pkgs.fira-math
      pkgs.ipafont
    ];

    prog.sesh.enable = true;

    catppuccin.ghostty.enable = true;

    xdg.configFile = lib.mkIf pkgs.stdenv.isDarwin (
      lib.mkMerge [
        {
          "ghostty/config" = {
            source = keyValue.generate "ghostty-config" settings;
          };
        }
        (lib.mapAttrs' (name: value: {
          name = "ghostty/themes/${name}";
          value = {
            source = keyValue.generate "ghostty-${name}-theme" value;
          };
        }) themes)
      ]
    );

    programs.bash.initExtra = lib.mkIf pkgs.stdenv.isDarwin (
      lib.mkOrder 101 ''
        if [[ -n "''${GHOSTTY_RESOURCES_DIR}" ]]; then
          builtin source "''${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
        fi
      ''
    );
    programs.fish.shellInit = lib.mkIf pkgs.stdenv.isDarwin ''
      if set -q GHOSTTY_RESOURCES_DIR
        source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
      end
    '';

    programs.zsh.initContent = lib.mkIf pkgs.stdenv.isDarwin ''
      if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
      fi
    '';

    programs.ghostty = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      package = cfg.package;

      settings = settings;

      themes = themes;
    };

  };
}
