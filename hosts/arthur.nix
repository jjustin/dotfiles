{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  myvars.host.personal = true;

  myvars.unfreePackages = [
    (lib.getName pkgs.rar)
  ];

  my.services.caps2esc.enable = true;

  users.users.${config.myvars.user.username} = {
    name = config.myvars.user.username;
    home = config.myvars.user.homeDirectory;
  };
}
