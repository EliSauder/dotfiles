{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      gst-plugin-spotify = pkgs.rustPlatform.buildRustPackage rec {
        pname = "gst-plugin-spotify";
        version = "1.0.1";
        src = pkgs.fetchGit {
          url = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs";
          rev = "9af4ac41b92b2df9367cf288bdf7b72ad504607e";
          #sha256 = "sha256-8jiGbk13Vy5wBEtudbpv0okOv7gVTwGKtL85sDs78Lc=";
          sha256 = lib.fakeHash;
        };

        nativeBuildInputs = [
          pkgs.gst_all_1.gstreamer
          pkgs.gst_all_1.gst-plugins-base
          pkgs.pkg-config
          pkgs.gst_all_1.gst-devtools
        ];

        cargoBuildFlags = [
          "--package gst-plugin-spotify"
          "--release"
        ];

        buildInputs = [
          pkgs.gst_all_1.gstreamer
          pkgs.gst_all_1.gst-plugins-base
        ];

        cargoHash = lib.fakeHash;
      };
    })
  ];
}
