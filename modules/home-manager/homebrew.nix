{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  # https://github.com/koalalorenzo/home-manager-brew#usage
  homebrew = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;

    taps = [ ];

    formulae = [
      "mole"
      "podman"
    ]
    ++ lib.optionals config.my.vars.host.work [
      "graphviz" # for infrastructure-diagram-mcp-server
    ];

    casks = [
      "beekeeper-studio"
      "bitwarden"
      "brave-browser"
      "bruno"
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
      "syncthing-app"
      "visual-studio-code"
      "vlc"
      "zed"
      "zen"
    ]
    ++ lib.optionals config.my.vars.host.work [
      "meetingbar"
      "insomnia"
      "slack"
    ]
    ++ lib.optionals config.my.vars.host.personal [
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
