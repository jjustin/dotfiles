{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.syncthing;
in
{
  options.my.services.syncthing = {
    enable = mkEnableOption "syncthing";
    port = mkOption {
      type = types.int;
      default = 8384;
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "${config.my.vars.user.username}";
      dataDir = "/home/${config.my.vars.user.username}/Documents"; # Default folder for new synced folders
      configDir = "/home/${config.my.vars.user.username}/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "localhost:${toString cfg.port}";
    };

    my.services.caddy.services.sync = {
      port = cfg.port;
      additionalReverseProxyOptions = "header_up Host {upstream_hostport}";
    };
  };
}
