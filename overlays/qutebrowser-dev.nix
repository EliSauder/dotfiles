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
          rev = "e17fbafdec001f138b6babc4fa51521461b7a536";
          branchName = "issue-8533-fido2-user-verification";
          sha256 = "sha256-zIcNwC+oiMrNnQPpTtW7jIK2vDyp8a1WvRWSAFIhuig=";
          #sha256 = lib.fakeHash;
        };
      });
    })
  ];
}
