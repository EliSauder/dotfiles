{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.development;

  dotnet-combined =
    usedotnet7:
    (pkgs.dotnetCorePackages.combinePackages (
      [
        pkgs.dotnet-sdk_9
        pkgs.dotnet-sdk_8
      ]
      ++ lib.optionals usedotnet7 [
        pkgs.dotnet-sdk_7
      ]
    )).overrideAttrs
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
  imports = [
    ./programs
    ./ui
    ./development-darwin.nix
    ./development-linux.nix
  ];

  options.module = {
    development.enable = lib.mkEnableOption "Enable development module";
    development.enableDotnet7 = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {

    home.sessionPath = [
      "$HOME/.dotnet/tools"
    ];

    home.sessionVariables = {
      DOTNET_ROOT = "${dotnet-combined cfg.enableDotnet7}";
    };

    nixpkgs.config.permittedInsecurePackages = lib.mkIf cfg.enableDotnet7 [
      "dotnet-sdk-7.0.410"
    ];

    module.development-linux.enable = pkgs.stdenv.isLinux;
    module.development-darwin.enable = pkgs.stdenv.isDarwin;

    prog.direnv.enable = true;

    prog.grc.enable = true;

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

    home.file = {
      ".parallel/will-cite" = {
        recursive = true;
        enable = true;
        text = "";
      };
    };

    prog.kubecolor.enable = true;

    home.packages = [
      pkgs.wireshark
      pkgs.delve
      pkgs.gdlv
      pkgs.util-linux
      pkgs.parallel
      pkgs.rsync
      pkgs.grc
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
      pkgs.kubectx
      pkgs.k9s
      pkgs.fluxcd
      pkgs.gettext
      pkgs.dotnet-ef
      pkgs.pgadmin4-desktopmode
      pkgs.grpcurl
      pkgs.grpcui
      pkgs.nuget-to-json
      pkgs.winbox4

      pkgs.kubectl-cnpg
      pkgs.kubectl-tree
      pkgs.kubectl-graph
      pkgs.kubectl-ktop
      pkgs.kubectl-doctor

      (dotnet-combined cfg.enableDotnet7)
    ];
  };
}
