{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  my.vars.host = {
    work = true;
    hostName = "mccree";

  };

  my.vars.unfreePackages = [ (lib.getName pkgs.claude-code) ];
}
