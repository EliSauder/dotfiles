{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      dbeaver-with-drivers = prev.dbeaver-bin.overrideAttrs (oldAttrs: {
        buildInputs = [
          pkgs.mssql_jdbc
          pkgs.postgresql_jdbc
          pkgs.mysql_jdbc
          pkgs.sqlite-jdbc
        ];
      });
    })
  ];
}
