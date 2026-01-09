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
        src = pkgs.fetchgit {
          url = "https://github.com/coderkun/qutebrowser.git";
          rev = "dd377a79bbc737732f3fa4b77d70b27eedb0cfad";
          branchName = "issue-8533-fido2-user-verification";
          sha256 = "sha256-ctKfYRXPSB/hpt6jvHixBmXxCxQGp3BibOELJeRGV54=";
          #sha256 = lib.fakeHash;
        };
      });
    })
  ];
}
