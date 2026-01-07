{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      idrive = pkgs.stdenv.mkDerivation rec {
        name = "idrive";
        src = pkgs.fetchurl {
          url = "https://www.idrivedownloads.com/downloads/linux/linux-desktop/IDriveForLinux.deb?ctag=07192025";
          #hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          hash = "sha256-LijFYYxJbV3JJGN0slvKbzDOLpBjPW91eqI5CJ9uvDI=";
        };

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.makeWrapper
          pkgs.dpkg
        ];

        unpackPhase = ''
          runHook preUnpack
          dpkg-deb -R "$src" idrive
          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p "$out/"
          cp -r "idrive/opt" "$out/"
          cp -r "idrive/usr/share" "$out/"

          #"$out/opt/IDriveForLinux/resources/app.asar.unpacked/IdriveForLinux/idriveforlinux.bin" --install

          #chown root:root "$out/opt/IDriveForLinux/chrome-sandbox"
          #chmod 4755 "$out/opt/IDriveForLinux/chrome-sandbox"

          mkdir -p "$out/bin"
          ln -s "$out/opt/IDriveForLinux/idriveforlinux" "$out/bin/idriveforlinux"

          cat "idrive/DEBIAN/control" | grep Version | awk -F' ' '{print $2}' > "$out/opt/IDriveForLinux/AppVersion"

          substituteInPlace "$out/share/applications/idriveforlinux.desktop" --replace "/opt/IDriveForLinux" "$out/opt/IDriveForLinux"

          runHook postInstall
        '';

        #postFixup = ''
        #  wrapProgram $out/bin/idriveforlinux \
        #    --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath buildInputs}" \
        #    --set MY_APP_HOME "$out/opt/IDriveForLinux"
        #'';

        buildInputs = [
          pkgs.nss
          pkgs.curl
          pkgs.debianutils
          pkgs.gnutar
          pkgs.cron
          pkgs.glibc
          pkgs.libappindicator
          pkgs.libdrm
          pkgs.libgbm
          pkgs.alsa-lib
        ];
      };
    })
  ];
}
