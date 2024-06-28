{ config, pkgs, lib, ... }:

let cfg = config.my.networking;
in {
  options.my.networking = {
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "I have no hostname set!";
    };

    enableWakeOnLAN = lib.mkEnableOption "wake on lan";
    wakeOnLanInterface = lib.mkOption
      {
        type = lib.types.str;
        default = "eth0";
      };
  };

  config = {
    networking.hostName = cfg.hostName;

    networking.networkmanager.enable = true;

    networking.interfaces.${cfg.wakeOnLanInterface}.wakeOnLan.enable = cfg.enableWakeOnLAN;

    # use resolved for hostname resolution
    services.resolved.enable = true;

    # enable mdns resolution for resolved on all connections
    # see https://man.archlinux.org/man/NetworkManager.conf.5#CONNECTION_SECTION
    networking.networkmanager.connectionConfig."connection.mdns" = 2;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      hostName = cfg.hostName;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
  };
}
