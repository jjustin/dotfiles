{ config, pkgs, lib, ... }: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  my.services.caps2esc.enable = true;

  users.users.${config.myvars.user.username} = {
    name = config.myvars.user.username;
    home = config.myvars.user.homeDirectory;
  };

  services.nix-daemon.enable = true;
}
