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

  services.macos-remap-keys = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    keyboard = {
      Capslock = "Escape";
      NonUSBackslash = "GraveAccent";
    };
  };
}
