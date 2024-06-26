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
