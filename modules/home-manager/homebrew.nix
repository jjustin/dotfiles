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
    taps = [ ];

    formulae = [
      "mole"
    ]
    ++ lib.optionals my.vars.host.work [
      "graphviz" # for infrastructure-diagram-mcp-server
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
      "podman"
      "postman"
      "rectangle"
      "redis-insight"
      "screen-studio"
      "signal"
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
