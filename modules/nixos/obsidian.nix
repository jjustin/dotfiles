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
    my.vars.unfreePackages = mkIf cfg.confirmUnfree [
      (lib.getName pkgs.obsidian)
    ];

    environment.systemPackages = with pkgs; [
      obsidian
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    my.services.syncthing.enable = true;
  };
}
