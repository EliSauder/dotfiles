{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  cfg = config.prog.remmina;
  isUbuntu = specialArgs.distro == "ubuntu";
  nixGLStart = if isUbuntu then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL " else "";
in
{
  options.prog = {
    remmina.enable = lib.mkEnableOption "Enable remmina";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.remmina
      pkgs.freerdp
    ];

    services.remmina = {
      enable = true;
      systemdService.enable = true;
      addRdpMimeTypeAssoc = true;
    };

    systemd.user.services.remmina.Service.ExecStart =
      lib.mkForce "GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx ${nixGLStart}${lib.getExe config.services.remmina.package} ${lib.escapeShellArgs config.services.remmina.systemdService.startupFlags}";
  };
}
