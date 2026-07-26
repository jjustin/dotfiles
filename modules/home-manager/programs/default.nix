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
    ./atuin.nix
    ./git.nix
    ./ghostty.nix
    ./nixvim
    ./zsh
  ];

  programs = {
    direnv = {
      enable = true;
    };
  };

  services.macos-remap-keys = {
    enable = true;
    keyboard = {
      Capslock = "Escape";
      NonUSBackslash = "GraveAccent";
    };
  };
}
