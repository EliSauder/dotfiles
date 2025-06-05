{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      waybar_now_playing = pkgs.rustPlatform.buildRustPackage rec {
        pname = "waybar_now_playing";
        version = "1.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "cybergaz";
          repo = pname;
          rev = "b4480e34e9ac3f16ce0f9b313b9b78e4c342c335";
          #sha256 = "sha256-8jiGbk13Vy5wBEtudbpv0okOv7gVTwGKtL85sDs78Lc=";
          sha256 = "sha256-ANKUwtIQQKKzo1u6RAY8uIKG5EKpuZa1X/fI379KazY=";
        };

        #cargoHash = "sha256-LU1eaH7XZFOvZtHJhsBptQKckXK5xc9rbiWdGvampTE=";
        cargoHash = "sha256-7fjIqmk1A7uS16w8HD1+YOolHWiw5yKrLsB65I05qNI=";
      };
    })
  ];
}
