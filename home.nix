{
  config,
  lib,
  pkgs,
  pkgs-stable,
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

  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;

  isUbuntu = specialArgs.distro == "ubuntu";
  nixGLStart = if isUbuntu then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL " else "";

  dotnet-combined =
    (pkgs.dotnetCorePackages.combinePackages [
      pkgs.dotnet-sdk_7
      pkgs.dotnet-sdk_9
      pkgs.dotnet-sdk_8
    ]).overrideAttrs
      (
        finalAttrs: previousAttrs: {
          postBuild = (previousAttrs.postBuild or '''') + ''
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

  home.sessionPath = [
    "$HOME/.dotnet/tools"
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}";
  };

  xdg = {
    enable = true;
    autostart.enable = true;
    portal = {
      enable = isLinux;
      xdgOpenUsePortal = true;
    };
    userDirs = {
      enable = isLinux;
      createDirectories = true;
    };
    mime.enable = isLinux;
    mimeApps = {
      enable = isLinux;
    };
  };

  systemd.user.enable = isLinux;

  xsession.enable = isLinux;

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-7.0.410"
  ];

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
      "mqtt-explorer"
      "terraform"
      "1password"
      "1password-cli"
      "vault-bin"
      "nvidia"

      # Browser plugins
      "onepassword-password-manager"
      "languagetool"
      "flagfox"
    ];

  home.sessionVariables.GTK_IM_MODULE = lib.mkForce "";

  imports = [
    ./programs
    ./ui
  ];

  targets.genericLinux.enable = isLinux && specialArgs.distro != "nixos";

  ui.hyprland = {
    enable = isLinux;
    terminal = "${config.prog.ghostty.package}/bin/ghostty";
    browser = "${pkgs.firefox}/bin/firefox";
    fileManager = "${config.prog.dolphin.package}/bin/dolphin";
    useNvidia = specialArgs.distro == "ubuntu";
    keybinds = [
      "$mod, R, exec, uwsm app -- ${nixGLStart}${pkgs.remmina}/bin/remmina"
    ];
  };

  ui.toolkits = {
    enable = isLinux;
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
    enable = false;
    setdefault = true;
  };
  prog.firefox = {
    enable = true;
    setdefault = true;
  };
  prog.dolphin = {
    enable = isLinux;
    package = pkgs-stable.kdePackages.dolphin;
    default = true;
  };
  prog.nemo.enable = false;
  prog.onepassword = {
    enable = true;
    gitIntegration = isDarwin;
    sshIntegration = isDarwin;
  };
  prog.obsidian.enable = true;
  prog.reaper.enable = true;
  prog.spacedrive.enable = false;
  prog.ssh = {
    enable = true;
  };
  prog.wezterm.enable = true;
  prog.ghostty.enable = true;
  prog.kitty.enable = true;
  prog.neovim.enable = true;
  prog.gitws.enable = true;
  prog.git = {
    enable = true;
    editor = "nvim";
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
  prog.remmina.enable = true;

  ## The home.packages option allows you to install Nix packages into your
  ## environment.
  home.packages = [
    pkgs.util-linux
    pkgs.parallel
    pkgs.rsync
    pkgs.grc
    #pkgs.bruno
    #pkgs.bruno-cli
    pkgs.freerdp

    # Default dev env
    pkgs.go
    pkgs.gotools
    pkgs.dotnet-outdated
    pkgs.zig
    pkgs.rust-bin.stable.latest.default
    pkgs.pandoc
    pkgs.texliveFull
    pkgs.k3d
    pkgs.docker
    pkgs.terraform
    pkgs.kubernetes-helm
    pkgs.kubectl
    pkgs.kubectx
    pkgs.k9s
    pkgs.fluxcd
    pkgs.gettext
    pkgs.prismlauncher

    pkgs.spacedrive
    pkgs.pgadmin4
    pkgs.grpcurl
    pkgs.grpcui
    pkgs.nuget-to-json
    pkgs.mqtt-explorer

    dotnet-combined
    pkgs.dotnet-ef
  ]
  ++ (lib.optionals isLinux [
    pkgs.squirrel-sql
    pkgs.xwayland
    pkgs.dbeaver-with-drivers
    pkgs.mssql_jdbc
    pkgs.postgresql_jdbc
    pkgs.mysql_jdbc
    pkgs.sqlite-jdbc
  ])
  ++ (lib.optionals isUbuntu [
    pkgs.nixgl.auto.nixGLDefault
  ]);

  #programs.java.enable = true;

  services.gnome-keyring.enable = isLinux;

  i18n.inputMethod = {
    enable = isLinux;
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

  systemd.user.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };

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
