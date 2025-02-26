{ config, pkgs, inputs, lib, ... }:
{
  ## This handles the installation of homebrew itself and configures the taps. 
  ## Actual packages/casks installation is done later on in `homebrew.<...>`
  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = config.myvars.user.username;

    # Declarative tap management
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };

    # Enable fully-declarative tap management
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = true;
  };

  # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.enable
  homebrew = {
    enable = true;
    # register the taps from nix-homebrew
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation = {
      # Uninstall any casks that are not in the casks list
      cleanup = "uninstall";

      # upgrade the casks to latest available version. This should update only
      # to latest version available in the input taps.
      upgrade = true;
      # Don't update brew during installation. The installation is handled by
      # nix-homebrew and it should not be updated.
      autoUpdate = false;
    };
    # Don't auto update brew when running brew commands
    # See https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.global.autoUpdate
    global.autoUpdate = false;

    casks = [
      "beekeeper-studio"
      "bitwarden"
      "brave-browser"
      "chromium"
      "discord"
      "drawio"
      "firefox"
      "ghostty"
      "hex-fiend"
      "obsidian"
      "orbstack"
      "postman"
      "rectangle"
      "redis-insight"
      "screen-studio"
      "signal"
      "spotify"
      "syncthing"
      "visual-studio-code"
      "vlc"
    ] ++ lib.optionals config.myvars.host.work [
      "insomnia"
      "slack"
    ] ++ lib.optionals config.myvars.host.personal [
      "caffeine"
      "calibre"
      "obs"
      "qbittorrent"
      "whisky"
    ];
  };
}
