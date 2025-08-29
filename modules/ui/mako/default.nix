{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  cfg = config.ui.mako;
  isUbuntu = specialArgs.distro == "ubuntu";
  nixGLStart = if isUbuntu then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL " else "";
in
{
  options.ui = {
    mako.enable = lib.mkEnableOption "Enable Mako";
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      package = pkgs.mako;
      settings = {
        icons = true;
        sort = "-priority";
        default-timeout = 5000;
        group-by = "app-name,urgency";
      };
    };

    systemd.user.services."mako" = {
      Unit = {
        Description = "Lightweight Wayland notification daemon";
        Documentation = [ "man:mako(1)" ];
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecCondition = "/bin/sh -c '[ -n \"$WAYLAND_DISPLAY\" ]'";
        ExecStart = "${nixGLStart}${pkgs.mako}/bin/mako";
        ExecReload = "${nixGLStart}${pkgs.mako}/bin/makoctl reload";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    #xdg.autostart.entries = [
    #  "${pkgs.mako}/share/systemd/user/mako.service"
    #];
  };
}
