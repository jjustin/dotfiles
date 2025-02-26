{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.plex;
in
{
  options.my.services.plex = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    confirmUnfree = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.plex.extraGroups = [ "storage" ];

    myvars.unfreePackages = mkIf cfg.confirmUnfree [
      (lib.getName pkgs.plex)
    ];

    services.plex = {
      enable = true;
      openFirewall = true;
      user = "plex";
      group = "plex";
    };

    my.services.udev.rules = [
      # Stop plex when on battery
      ''SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.systemd}/bin/systemctl stop plex.service"''
      # Start plex when on AC
      ''SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.systemd}/bin/systemctl start plex.service"''
    ];
  };
}
