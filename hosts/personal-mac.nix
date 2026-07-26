{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  my.vars.host = {
    personal = true;
    hostName = "hornet";
  };

  my.vars.unfreePackages = [ (lib.getName pkgs.rar) ];
}
