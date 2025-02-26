# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # include NixOS-WSL modules
    inputs.nix-wsl.nixosModules.wsl
  ];

  my.networking.hostName = "kratos";

  wsl.enable = true;
  wsl.defaultUser = config.myvars.user.username;
}
