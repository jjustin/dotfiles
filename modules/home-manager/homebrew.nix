{
  my,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  # https://github.com/koalalorenzo/home-manager-brew#usage
  homebrew = {
    taps = [
      {
        name = "homebrew/core";
        repo = "git@github.com/homebrew/homebrew-core.git";
      }
      {
        name = "homebrew/cask";
        repo = "git@github.com/homebrew/homebrew-cask.git";
      }
    ];

    formulae = [
      "mole"
    ];

    casks = [
      "beekeeper-studio"
      "bitwarden"
      "brave-browser"
      "bruno"
      "chromium"
      "claude-code"
      "discord"
      "drawio"
      "firefox"
      "ghostty"
      "hex-fiend"
      "numi"
      "obsidian"
      "orbstack"
      "postman"
      "rectangle"
      "redis-insight"
      "screen-studio"
      "signal"
      "spotify"
      "syncthing-app"
      "visual-studio-code"
      "vlc"
      "zed"
      "zen"
    ]
    ++ lib.optionals my.vars.host.work [
      "meetingbar"
      "insomnia"
      "slack"
    ]
    ++ lib.optionals my.vars.host.personal [
      "balenaetcher"
      "caffeine"
      "calibre"
      "mp3tag"
      "obs"
      "steam"
      "qbittorrent"
      "whisky"
    ];
  };
}
