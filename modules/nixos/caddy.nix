{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

with lib;
let
  cfg = config.my.services.caddy;
in
{
  options.my.services.caddy = {
    enable = mkEnableOption "caddy";

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open HTTP and HTTPS ports to the outside network.
      '';
    };

    services = mkOption {
      description = ''
        service to expose through caddy
      '';
      type = types.attrsOf (
        types.submodule ({
          options = {
            port = mkOption {
              type = (types.addCheck types.int (x: x > 0 && x <= 65535));
              description = ''
                Port on which the service is running
              '';
              default = throw "port not set";
            };

            public = mkOption {
              type = types.bool;
              description = ''
                should the service be exposed through cloudflare tunnel? False exposes it to the local network
              '';
              default = false;
            };

            additionalReverseProxyOptions = mkOption {
              type = types.lines;
              description = ''
                Additional lines to include in the reverse proxy block.
              '';
              default = "";
            };
          };
        })
      );
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels.${config.my.private.cloudflare.tunnelId} = {
        credentialsFile = config.my.private.cloudflare.tunnelCredentials;
        default = "http_status:404";
        ingress = mkMerge (
          map (
            key:
            let
              serviceCfg = cfg.services.${key};
              optLocalSubpath = if serviceCfg.public then "" else "${config.my.vars.host.hostName}.local.";
            in
            {
              "${key}.${optLocalSubpath}${config.my.private.cloudflare.tunnelHostname}" = "http://localhost";
            }
          ) (builtins.attrNames cfg.services)
        );
      };
    };

    services.caddy = {
      enable = true;

      package = pkgs.caddy.withPlugins {
        plugins =
          let
            cfRev = builtins.substring 0 12 inputs.caddy-cloudflare.rev;
            cfLastModifiedDate = inputs.caddy-cloudflare.lastModifiedDate;
          in
          [
            ## This approach to versioning might not be the best but it works until a release of this plugin is made
            "github.com/caddy-dns/cloudflare@v0.0.0-${cfLastModifiedDate}-${cfRev}"
          ];
        hash = "sha256-3nvVGW+ZHLxQxc1VCc/oTzCLZPBKgw4mhn+O3IoyiSs=";
      };

      virtualHosts = mkMerge (
        lib.lists.flatten [
          {
            "ping.localhost" = {
              extraConfig = ''
                respond pong
              '';
            };
          }

          (map (
            key:
            let
              serviceCfg = cfg.services.${key};
              optLocalSubpath = if serviceCfg.public then "" else "${config.my.vars.host.hostName}.local.";
              # This might seem a bit contradictory - public services are accessed through cloudflare tunnel and it's the tunnel that terminates TLS. Local-network communciation uses caddy for TLS termination.
              port = if serviceCfg.public then ":80" else "";
            in
            {
              "${key}.${optLocalSubpath}${config.my.private.cloudflare.tunnelHostname}${port}" = {
                extraConfig = ''
                  reverse_proxy localhost:${toString serviceCfg.port} ${
                    if serviceCfg.additionalReverseProxyOptions != "" then
                      ''
                        {
                          ${serviceCfg.additionalReverseProxyOptions}
                        }
                      ''
                    else
                      ""
                  }

                  tls {
                    dns cloudflare {
                      zone_token ${config.my.private.cloudflare.zoneToken}
                      api_token ${config.my.private.cloudflare.apiToken}
                    }
                  }
                '';
              };
            }
          ) (builtins.attrNames cfg.services))
        ]
      );
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        80
        443
      ];
    };

  };
}
