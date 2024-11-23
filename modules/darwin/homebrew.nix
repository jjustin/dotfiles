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

  homebrew = {
    enable = true;
    casks = [
      "beekeeper-studio"
      "brave-browser"
      "chromium"
      "discord"
      "drawio"
      "firefox"
      "hex-fiend"
      "insomnia"
      "iterm2"
      "obsidian"
      "orbstack"
      "postman"
      "rectangle"
      "redisinsight"
      "screen-studio"
      "signal"
      "slack"
      "spotify"
      "syncthing"
      "visual-studio-code"
      "vlc"
    ] ++ lib.optionals config.myvars.host.personal [
      "qbittorrent"
    ];
    onActivation.cleanup = "uninstall";
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
