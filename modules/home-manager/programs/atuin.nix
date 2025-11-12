{ my, ... }:
{
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_frequency = "30m";
      sync_address = my.private.atuin.endpoint;
      search_mode = "fuzzy";
    };
  };
}
