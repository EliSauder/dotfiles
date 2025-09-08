{
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      gst-plugins-spotify = pkgs.stdenv.mkDerivation {
        pname = "gst-plugins-spotify";
        version = "0.15.0-alpha.1-2";
        src = pkgs.fetchurl {
          url = "https://github.com/kingosticks/gst-plugins-rs-build/releases/download/gst-plugin-spotify_0.15.0-alpha.1-2/libgstspotify.so";
          sha256 = "sha256-lRuougWforiUuQz7jvf6qyhP2pepyYDAQ3ZbHHNdksE=";
          #sha256 = lib.fakeHash;
        };
        phases = [ "installPhase" ];
        buildInputs = [
          pkgs.gst_all_1.gstreamer
          pkgs.gst_all_1.gst-plugins-base
          pkgs.gst_all_1.gst-devtools
        ];
        installPhase = ''
          mkdir -p "$out/lib/gstreamer-1.0"
          cp -T "$src" "$out/lib/gstreamer-1.0/libgstspotify.so"
          chmod 0444 "$out/lib/gstreamer-1.0/libgstspotify.so"
        '';

        meta.priority = 5;
      };
    })
    (final: prev: {
      gst-plugin-spotify = pkgs.rustPlatform.buildRustPackage {
        pname = "gst-plugin-spotify";
        version = "1.0.1";
        src = pkgs.fetchgit {
          url = "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs";
          rev = "9af4ac41b92b2df9367cf288bdf7b72ad504607e";
          sha256 = "sha256-IZBCXl6JPGSui0cHWmwWqMLTzed2NZ5Bx2bRfBbSDV8=";
        };

        doCheck = false;

        nativeBuildInputs = [
          pkgs.pango
          pkgs.webrtc-audio-processing_1
          pkgs.webrtc-audio-processing
          pkgs.gst_all_1.gstreamer
          pkgs.gst_all_1.gst-plugins-base
          pkgs.gst_all_1.gst-plugins-bad
          pkgs.gst_all_1.gst-plugins-ugly
          pkgs.gst_all_1.gst-plugins-good
          pkgs.gst_all_1.gst-plugins-rs
          pkgs.pkg-config
          pkgs.gst_all_1.gst-devtools
          pkgs.gst_all_1.gst-rtsp-server
          pkgs.gst_all_1.gst-libav
          pkgs.glib
          pkgs.glibc
          pkgs.gst_all_1.gst-editing-services
        ];

        cargoBuildFlags = [
          "--package gst-plugin-spotify"
        ];

        buildInputs = [
          pkgs.pango
          pkgs.gst_all_1.gstreamer
          pkgs.gst_all_1.gst-plugins-base
          pkgs.gst_all_1.gst-plugins-bad
          pkgs.gst_all_1.gst-plugins-ugly
          pkgs.gst_all_1.gst-plugins-good
          pkgs.gst_all_1.gst-plugins-rs
          pkgs.gst_all_1.gst-devtools
          pkgs.gst_all_1.gst-rtsp-server
          pkgs.gst_all_1.gst-libav
          pkgs.gst_all_1.gst-editing-services
        ];

        cargoHash = "sha256-eojK6ZYC7agvBBBth7aMvhGm6k12ofHf2PUaT6gldr8=";
      };
    })
  ];
}
