{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.printing;
in
{
  options.my.services.printing = {
    enable = mkEnableOption "printing";
    openFirewall = mkEnableOption "open firewall";
    sharing = mkEnableOption "share printers over network";
    drivers = mkOption {
      description = "printers to provide the printing service with";
      type = with types; listOf package;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = cfg.drivers;
      openFirewall = cfg.openFirewall;
      listenAddresses = lib.mkIf cfg.sharing [ "*:631" ];
      allowFrom = lib.mkIf cfg.sharing [ "all" ];
      browsing = cfg.sharing;
      defaultShared = cfg.sharing;
    };

    users.users.${config.my.vars.user.username}.extraGroups = [ "lp" ];

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = cfg.openFirewall;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };
}
