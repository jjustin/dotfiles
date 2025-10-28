{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.smb;
in
{
  options.my.services.smb = {
    enable = mkEnableOption "smb";
    enableRootKeyLogin = mkEnableOption "root key login";
  };

  config = lib.mkIf cfg.enable {
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.1. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "private" = {
          "path" = "/run/media/${config.my.vars.user.username}/OneTouchBU";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = config.my.vars.user.username;
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
