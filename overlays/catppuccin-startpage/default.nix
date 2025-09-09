{
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      catppuccin-startpage = pkgs.stdenv.mkDerivation rec {
        pname = "catppuccin-startpage";
        version = "0.1.0";
        src = pkgs.fetchFromGitHub {
          owner = "pivoshenko";
          repo = pname;
          rev = "c7ab74cd2439ad8e78c8319a66639cb585b0e984";
          #sha256 = "sha256-8jiGbk13Vy5wBEtudbpv0okOv7gVTwGKtL85sDs78Lc=";
          sha256 = "sha256-NazFL6hu+wZ55y1nLnNFL91FgdrsKSPObz2YC16BSH4=";
        };
        phases = [ "installPhase" ];
        installPhase = ''
          mkdir -p "$out"
          cp -T -r "$src" "$out"
          cp ./userconfig.js "$out"
          rm "$out/userconfig.example.js"
        '';
      };
    })
  ];
}
