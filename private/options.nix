{
  config,
  lib,
  options,
  ...
}:

with lib;
{
  options.my.private = {
    gitIncludes = mkOption {
      type = types.attrsOf types.anything;
      description = "see options.home-manager.programs.git.includes.contents";
      default = { };
    };

    cloudflare = {
      apiToken = mkOption {
        type = types.str;
        default = throw "Cloudflare api token not configured";
      };

      zoneToken = mkOption {
        type = types.str;
        default = throw "Cloudflare zone token not configured";
      };

      tunnelCredentials = mkOption {
        type = types.path;
        default = throw "Cloudflare tunnel credentials not configured";
      };

      tunnelId = mkOption {
        type = types.str;
        default = throw "Cloudflare tunnel id not configured";
      };

      tunnelHostname = mkOption {
        type = types.str;
        default = throw "Cloudflare hostname not configured";
      };
    };
  };
}
