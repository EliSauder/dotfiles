{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      omnisharp-roslyn = pkgs.omnisharp-roslyn.override (oldAttrs: rec {
        pname = "omnisharp-roslyn";
        version = "1.39.13";
        src = pkgs.fetchFromGitHub {
          owner = "OmniSharp";
          repo = pname;
          rev = "9b86af51a009e7e97003649b57d71e097c8ac961";
          sha256 = "";
        };
      });
    })
  ];
}
