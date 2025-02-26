{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.obsidian;
in
{
  options.my.obsidian = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    confirmUnfree = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    myvars.unfreePackages = mkIf cfg.confirmUnfree [
      (lib.getName pkgs.obsidian)
    ];

    environment.systemPackages = with pkgs; [
      obsidian
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    services.syncthing = {
      enable = true;
      user = "jjustin";
      dataDir = "/home/jjustin/Documents"; # Default folder for new synced folders
      configDir = "/home/jjustin/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };
}
