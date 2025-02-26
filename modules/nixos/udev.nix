{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.udev;
in
{
  options.my.services.udev = {
    rules = mkOption {
      type = types.listOf types.str;
    };
  };

  config = {
    my.services.udev.rules = [
      # Automount usb devices
      ''ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --timeout-idle-sec=300 --collect -o \"uid=${toString config.users.users.jjustin.uid},gid=${toString config.users.groups.storage.gid},umask=002\" $devnode /run/media/jjustin/$env{ID_FS_LABEL}"''
    ];

    services.udev = {
      enable = true;
      extraRules = lib.strings.concatStringsSep "\n" cfg.rules;
    };
  };
}
