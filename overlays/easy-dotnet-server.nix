{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      # bearpro/easy-dotnet-nix pins an EasyDotnet server too old for the
      # easy-dotnet.nvim plugin in nixpkgs, so build a newer one here.
      easy-dotnet-server =
        let
          dotnetSdk = final.dotnetCorePackages.sdk_10_0;
          system = final.stdenv.hostPlatform.system;
          nativeRid =
            {
              "x86_64-linux" = "linux-x64";
              "aarch64-linux" = "linux-arm64";
            }
            .${system};
          foreignRid =
            {
              "x86_64-linux" = "linux-arm64";
              "aarch64-linux" = "linux-x64";
            }
            .${system};
        in
        final.stdenv.mkDerivation rec {
          pname = "easy-dotnet";
          version = "3.4.31";

          src = final.fetchurl {
            url = "https://api.nuget.org/v3-flatcontainer/easydotnet/${version}/easydotnet.${version}.nupkg";
            hash = "sha256-udF/75cPvDJ1Go5+U0W11xfuhO5egMxyLuqEzCyr8po=";
          };

          nativeBuildInputs = [
            final.autoPatchelfHook
            final.makeWrapper
            final.unzip
          ];

          buildInputs = [ final.stdenv.cc.cc ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = ''
            runHook preUnpack
            unzip -q "$src" -d source
            runHook postUnpack
          '';

          installPhase = ''
            runHook preInstall

            install -d "$out/bin" "$out/lib/tools"
            cp -R source/tools/. "$out/lib/tools/"

            rm -rf \
              "$out/lib/tools/netcoredbg/${foreignRid}" \
              "$out/lib/tools/dncdbg/${foreignRid}" \
              "$out/lib/tools/sharpdbg/runtimes/${foreignRid}" \
              "$out/lib/tools/sharpdbg/runtimes/linux-musl-x64" \
              "$out/lib/tools/sharpdbg/runtimes/linux-musl-arm" \
              "$out/lib/tools/sharpdbg/runtimes/linux-musl-arm64"
            find "$out/lib/tools" -type f -name '*.dbg' -delete
            chmod +x \
              "$out/lib/tools/netcoredbg/${nativeRid}/netcoredbg" \
              "$out/lib/tools/dncdbg/${nativeRid}/dncdbg"

            rm "$out/lib/tools/Aspire/net8.0/EasyDotnet.Aspire"
            makeWrapper "${dotnetSdk}/bin/dotnet" \
              "$out/lib/tools/Aspire/net8.0/EasyDotnet.Aspire" \
              --add-flags "$out/lib/tools/Aspire/net8.0/EasyDotnet.Aspire.dll"

            rm "$out/lib/tools/net8.0/any/BuildServer/net8.0/EasyDotnet.BuildServer"
            makeWrapper "${dotnetSdk}/bin/dotnet" \
              "$out/lib/tools/net8.0/any/BuildServer/net8.0/EasyDotnet.BuildServer" \
              --add-flags "$out/lib/tools/net8.0/any/BuildServer/net8.0/EasyDotnet.BuildServer.dll"

            rm "$out/lib/tools/AppWrapper/net8.0/EasyDotnet.AppWrapper"
            makeWrapper "${dotnetSdk}/bin/dotnet" \
              "$out/lib/tools/AppWrapper/net8.0/EasyDotnet.AppWrapper" \
              --add-flags "$out/lib/tools/AppWrapper/net8.0/EasyDotnet.AppWrapper.dll"

            makeWrapper "${dotnetSdk}/bin/dotnet" "$out/bin/dotnet-easydotnet" \
              --add-flags "$out/lib/tools/net8.0/any/EasyDotnet.IDE.dll"

            runHook postInstall
          '';

          meta = {
            description = "EasyDotnet server and tools";
            homepage = "https://github.com/GustavEikaas/easy-dotnet-server";
            platforms = [
              "x86_64-linux"
              "aarch64-linux"
            ];
            mainProgram = "dotnet-easydotnet";
          };
        };

      roslyn-language-server =
        let
          dotnetSdk = final.dotnetCorePackages.sdk_10_0;
          rid =
            {
              "x86_64-linux" = "linux-x64";
              "aarch64-linux" = "linux-arm64";
            }
            .${final.stdenv.hostPlatform.system};
          hashes = {
            "x86_64-linux" = "sha256-loD9Y7r5USv4/5NyYP2j6MQCkDMQuqEbtfJNav326sY=";
            "aarch64-linux" = "sha256-in0clOmiUJHmBJ5pCuk7uPtdEhHnyeshs0wWQAyovos=";
          };
        in
        final.stdenvNoCC.mkDerivation rec {
          pname = "roslyn-language-server";
          version = "5.11.0";

          src = final.fetchurl {
            url = "https://api.nuget.org/v3-flatcontainer/${pname}.${rid}/${version}/${pname}.${rid}.${version}.nupkg";
            hash = hashes.${final.stdenv.hostPlatform.system};
          };

          nativeBuildInputs = [
            final.makeWrapper
            final.unzip
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = ''
            runHook preUnpack
            unzip -q "$src" -d source
            runHook postUnpack
          '';

          installPhase = ''
            runHook preInstall

            install -d "$out/bin" "$out/lib/roslyn-language-server"
            cp -R "source/tools/net10.0/${rid}/." "$out/lib/roslyn-language-server/"

            makeWrapper "${dotnetSdk}/bin/dotnet" "$out/bin/roslyn-language-server" \
              --add-flags "$out/lib/roslyn-language-server/Microsoft.CodeAnalysis.LanguageServer.dll"

            runHook postInstall
          '';

          meta = {
            description = "Official Roslyn language server";
            homepage = "https://github.com/dotnet/roslyn";
            platforms = [
              "x86_64-linux"
              "aarch64-linux"
            ];
            mainProgram = "roslyn-language-server";
          };
        };
    })
  ];
}
