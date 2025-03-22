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
  };
}
