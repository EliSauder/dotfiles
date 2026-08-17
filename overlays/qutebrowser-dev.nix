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
          rev = "4c0fc4fdf6721028957cddd3075d8df09e170951";
          branchName = "issue-8533-fido2-user-verification";
          sha256 = "sha256-BVCbCSh80J7UQm5G2Ub1Ah4yzm58PYiNHR/mbSynDeE=";
          #sha256 = lib.fakeHash;
        };
      });
    })
  ];
}
