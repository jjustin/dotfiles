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

  my.vars.host.hostName = "isaac";

  wsl.enable = true;
  wsl.defaultUser = config.my.vars.user.username;
  wsl.docker-desktop.enable = true;

  # VSCode server fix: https://nixos.wiki/wiki/Visual_Studio_Code#nix-ld
  programs.nix-ld.enable = true;
}
