{ config, ... }:
{
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_frequency = "30m";
      sync_address = config.my.private.atuin.endpoint;
      search_mode = "fuzzy";
    };
  };
}
