{ config, pkgs, lib, ... }:

let cfg = config.my.networking;
in {
  options.my.networking = {
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "I have no hostname set!";
    };
  };

  config = {
    networking.hostName = cfg.hostName;

    networking.networkmanager.enable = true;
  };
}
