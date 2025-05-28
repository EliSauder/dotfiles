{
  config,
  pkgs,
  lib,
  ...
}:
let
in
{
  nixpkgs.overlays = [
    (final: prev: {
      omnisharp = pkgs.mkDerivation {
        pname = "omnisharp-roslyn";
        version = "1.39.13";
        srcs = [
          (pkgs.fetchurl {
            url = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe";
            sha256 = "";
          })
          (pkgs.fetchurl {
            url = "https://cakebuild.net/download/bootstrapper/packages";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          })
          (pkgs.fetchFromGitHub {
            owner = "OmniSharp";
            repo = "omnisharp-roslyn";
            rev = "9b86af51a009e7e97003649b57d71e097c8ac961";
            sha256 = "";
          })
          (pkgs.buildDotnetModule {
            pname = "omnisharp-deps";
            version = "1.39.13";
            nugetDeps = ./deps.json;
          })
        ];

        unpackPhase = ''
          mkdir tools

          for src in $src; do
            if [[ $src == *"nuget"* ]]; then
              cp "$src" tools/nuget.exe
            if [[ $src == *"package"* ]]; then
              cp "$src" tools/packages.config
            if [[ $src == *"omnisharp-deps"* ]]; then
              ls -la $src
            else
              cp -r "$src/"* ./
            fi
          done

          ${pkgs.coreutils-full}/bin/md5sum tools/packages.config | awk '{ print $1 }' >| tools/packages.config.md5sum

          find ./ -type f -exec {} ${pkgs.dos2unix}/bin/dos2unix {} 2> /dev/null \;
        '';

      };
    })
  ];
}
