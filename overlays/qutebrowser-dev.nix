{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      qutebrowser-dev = prev.qutebrowser.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "coderkun";
          repo = "qutebrowser";
          rev = "4b38ef7a15f7a02a857667c8dbbc3c94ab915b50";
          branch = "issue-8533-fido2-user-verification";
          #sha256 = "sha256-8jiGbk13Vy5wBEtudbpv0okOv7gVTwGKtL85sDs78Lc=";
          sha256 = lib.fakeHash;
        };
      });
    })
  ];
}
