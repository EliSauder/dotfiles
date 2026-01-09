{
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      impl = pkgs.buildGoModule rec {
        pname = "impl";
        version = "3a42bca5415cec8a41d9cc05e9e003cf96932b91";
        src = pkgs.fetchFromGitHub {
          owner = "EliSauder";
          repo = pname;
          rev = version;
          #sha256 = "sha256-8jiGbk13Vy5wBEtudbpv0okOv7gVTwGKtL85sDs78Lc=";
          sha256 = "sha256-o9fyKc9QfZJTGW7mjnCiRL7kGouF+YdCUcaX5dXDXeQ=";
        };

        #cargoHash = "sha256-LU1eaH7XZFOvZtHJhsBptQKckXK5xc9rbiWdGvampTE=";
        vendorHash = "sha256-vTqDoM/LK5SHkayLKYig+tCrXLelOoILmQGCxlTWHog=";
      };
    })
  ];
}
