{
  config,
  pkgs,
  ...
}:
{

  home.packages = [
    pkgs.sops
    pkgs.age
    pkgs.ssh-to-age
  ];

  sops = {
    defaultSopsFile = ./../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/keys.txt";

    secrets.apps.spotify.id = { };
    secrets.apps.spotify.secret = { };
  };

}
