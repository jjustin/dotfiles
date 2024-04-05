{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.my.services.qbittorrent;
  configDir = "${cfg.userHomeDir}/.config";
in
{
  options.my.services.qbittorrent = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Run qBittorrent headlessly as systemwide daemon
      '';
    };

    userHomeDir = mkOption {
      type = types.path;
      default = "/var/lib/qbittorrent";
      description = ''
        The directory where qBittorrent will store configs.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        qBittorrent web UI port.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open services.qBittorrent.port to the outside network.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qbittorrent ];

    nixpkgs.overlays = [
      (final: prev: {
        qbittorrent = prev.qbittorrent.override { guiSupport = false; };
      })
    ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.qbittorrent = {
      after = [ "network.target" ];
      description = "qBittorrent Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.qbittorrent ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.qbittorrent}/bin/qbittorrent-nox \
            --profile=${configDir} \
            --webui-port=${toString cfg.port}
        '';
        User = "qbittorrent";
        Group = "qbittorrent";
      };
    };

    users.users.qbittorrent = {
      group = "qbittorrent";
      home = cfg.userHomeDir;
      createHome = true;
      isSystemUser = true;
      description = "qBittorrent Daemon user";
      extraGroups = [ "storage" ];
    };

    users.groups.qbittorrent = { gid = null; };
  };
}
