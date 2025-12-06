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
          rev = "62d5407d2f33fe702a9f90620c21e5f68d996510";
          branchName = "issue-8533-fido2-user-verification";
          sha256 = "sha256-5PFvAqgeJ6Y+AiA4LVHPYgbhWmpTEHjnqzjplNLyG28=";
          #sha256 = "sha256-Uv5zQvmkfdib5j+y5nRw1VAqHnVNgVR58Mtxm5iXCOM=";
        };
      });
    })
  ];
}
