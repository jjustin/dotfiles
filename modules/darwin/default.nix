{
  config,
  lib,
  pkgs,
  nixpkgs,
  inputs,
  ...
}:
{
  imports = [
    ./caps2esc.nix
    ./homebrew.nix
    ./packages.nix
    ./system.nix
  ];
  my.vars.user.homeDirectory = "/Users/${config.my.vars.user.username}";
  users.users.${config.my.vars.user.username} = {
    name = config.my.vars.user.username;
    home = config.my.vars.user.homeDirectory;
  };

  system.primaryUser = config.my.vars.user.username;

  system.stateVersion = 5;
}
