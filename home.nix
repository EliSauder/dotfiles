{
  config,
  lib,
  pkgs,
  inputs,
  specialArgs,
  ...
}:
let
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };

  dotnet-combined =
    (pkgs.dotnetCorePackages.combinePackages [
      pkgs.dotnet-sdk_9
      pkgs.dotnet-sdk_8
    ]).overrideAttrs
      (
        finalAttrs: previousAttrs: {
          postBuild =
            (previousAttrs.postBuild or '''')
            + ''
              for i in $out/sdk/*
              do
                i=$(basename $i)
                mkdir -p $out/metadata/workloads/''${i/-*}
                touch $out/metadata/workloads/''${i/-*}/userlocal
              done
            '';
        }
      );
in
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

  #home.sessionPath = [
  #  "$HOME/.dotnet/tools"
  #];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}";
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

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "discord"
      "obsidian"
      "perfecto-calligraphy-pu-ttf"
      "shelley-allegro-bt-otf"
      "reaper"
      "winbox"

      # Browser plugins
      "onepassword-password-manager"
      "languagetool"
      "fakespot-fake-reviews-amazon"
      "flagfox"
    ];

  home.sessionVariables.GTK_IM_MODULE = lib.mkForce "";

  imports = [
    ./programs
    ./ui
  ];

  targets.genericLinux.enable = specialArgs.distro != "nixos";

  ui.hyprland = {
    enable = true;
    terminal = "${pkgs.wezterm}/bin/wezterm";
    #browser = "${pkgs.firefox}/bin/firefox";
    browser = "${pkgs.floorp}/bin/floorp";
    fileManager = "${pkgs.spacedrive}/bin/spacedrive";
    useNvidia = specialArgs.distro == "ubuntu";
    keybinds = [
      "$mod, R, exec, uwsm app -- ${pkgs.remmina}/bin/remmina"
    ];
  };

  ui.toolkits = {
    enable = true;
    enableGtk = true;
    enableQt = true;
  };
  # -- Handle in sys config
  # prog.steam.enable = true;
  # prog.inkscape.enable = true;
  # prog.libreoffice.enable = true;
  # prog.obs.enable = true;

  prog.discord.enable = false;
  prog.direnv.enable = true;
  prog.librewolf.enable = true;
  prog.floorp = {
    enable = true;
    setdefault = true;
  };
  prog.obsidian.enable = true;
  prog.reaper.enable = true;
  prog.spacedrive.enable = true;
  prog.ssh.enable = true;
  prog.wezterm.enable = true;
  prog.kitty.enable = true;
  prog.neovim.enable = true;
  prog.git = {
    enable = true;
    editor = "${config.programs.nixvim.package}/bin/nvim";
  };
  prog.bash.enable = true;
  prog.starship.enable = true;
  prog.fish.enable = true;
  prog.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
  };
  prog.zoxide.enable = true;
  prog.sesh.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.nemo
    pkgs.util-linux
    pkgs.parallel
    pkgs.rsync
    #pkgs.bruno
    #pkgs.bruno-cli
    pkgs.freerdp
    pkgs.xwayland

    # Default dev env
    pkgs.go
    pkgs.gotools
    pkgs.dotnet-outdated
    pkgs.zig
    pkgs.rust-bin.stable.latest.default

    pkgs.nixgl.nixGLIntel
    pkgs.remmina
    pkgs.spacedrive
    pkgs.pgadmin4
    pkgs.grpcurl
    pkgs.grpcui
    pkgs.squirrel-sql
    pkgs.dbeaver-bin
    pkgs.mssql_jdbc
    pkgs.postgresql_jdbc
    pkgs.mysql_jdbc
    pkgs.sqlite-jdbc
    pkgs.nuget-to-json

    dotnet-combined
  ];

  programs.java.enable = true;

  services.gnome-keyring.enable = true;
  services.polkit-gnome.enable = true;

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

  home.file = {
    ".parallel/will-cite" = {
      recursive = true;
      enable = true;
      text = "";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    addApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      apps_source="${apps}/Applications"
      moniker="Nix Trampolines"
      app_target_base="$HOME/Applications"
      app_target="$app_target_base/$moniker"
      rm -f "$app_target/*"
      mkdir -p "$app_target"
      ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
    '';
  };

}
