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

  home.homeDirectory = "/Users/esauder";
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
  };

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
    ./../../programs
    ./../../ui
  ];

  prog.discord.enable = true;
  prog.direnv.enable = true;
  prog.librewolf.enable = true;
  prog.firefox = {
    enable = true;
    setdefault = true;
  };
  prog.onepassword = {
    enable = true;
    gitIntegration = true;
    sshIntegration = true;
  };
  prog.reaper.enable = true;
  prog.ssh = {
    enable = true;
  };
  prog.ghostty.enable = true;
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
    pkgs.prismlauncher
    pkgs.util-linux
    pkgs.parallel
    pkgs.rsync
    pkgs.grc
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

    pkgs.pgadmin4
    pkgs.grpcurl
    pkgs.grpcui
    pkgs.nuget-to-json
    pkgs.mqtt-explorer

    dotnet-combined
    pkgs.dotnet-ef
  ];

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
