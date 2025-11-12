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

    host = mkOption {
      type = types.string;
      default = "127.0.0.1";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open port to the outside network.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "${config.my.vars.user.username}";
      dataDir = "/home/${config.my.vars.user.username}/Documents"; # Default folder for new synced folders
      configDir = "/home/${config.my.vars.user.username}/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "${cfg.host}:${toString cfg.port}"; # exposed to docker
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.port
      ];
    };
  };
}
