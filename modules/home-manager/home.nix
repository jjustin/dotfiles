{
  config,
  lib,
  pkgs,
  nixpkgs,
  inputs,
  myvars,
  private,
  ...
}:

# https://nix-community.github.io/home-manager/options.xhtml

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs
  ];

  programs.home-manager.enable = true;

  home.username = myvars.user.username;
  home.homeDirectory = myvars.user.homeDirectory;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
