{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      idrive = pkgs.stdenv.mkDerivation {
        name = "idrive";
        src = pkgs.fetchurl {
          url = "https://www.idrivedownloads.com/downloads/linux/linux-desktop/IDriveForLinux.deb?ctag=07192025";
          #hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          hash = "sha256-LijFYYxJbV3JJGN0slvKbzDOLpBjPW91eqI5CJ9uvDI=";
        };
        phases = [
          "unpackPhase"
          "installPhase"
        ];

        nativeBuildInputs = [
          pkgs.dpkg
        ];

        unpackPhase = ''
          dpkg-deb -R "$src" idrive
        '';

        installPhase = ''
          mkdir -p "$out/"
          cp -r "idrive/opt" "$out/"
          cp -r "idrive/usr" "$out/"

          #"$out/opt/IDriveForLinux/resources/app.asar.unpacked/IdriveForLinux/idriveforlinux.bin" --install

          #chown root:root "$out/opt/IDriveForLinux/chrome-sandbox"
          #chmod 4755 "$out/opt/IDriveForLinux/chrome-sandbox"

          mkdir -p "$out/usr/local/bin"
          ln -s "$out/opt/IDriveForLinux/idriveforlinux" "$out/usr/local/bin/idriveforlinux"

          cat "idrive/DEBIAN/control" | grep Version | awk -F' ' '{print $2}' > "$out/opt/IDriveForLinux/AppVersion"
        '';

        buildInputs = [
          pkgs.nss
          pkgs.curl
          pkgs.debianutils
          pkgs.gnutar
          pkgs.cron
          pkgs.glibc
          pkgs.libappindicator
        ];
      };
    })
  ];
}
