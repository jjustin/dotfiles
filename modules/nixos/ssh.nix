{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.ssh;
in
{
  options.my.services.ssh = {
    enableAgent = mkEnableOption "ssh-agent";
    enableServer = mkEnableOption "ssh-server";
    enableRootKeyLogin = mkEnableOption "root key login";
  };

  config = {
    services.openssh = lib.mkIf cfg.enableServer {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "without-password";
      };
    };
  
    users.users.root = lib.mkIf cfg.enableRootKeyLogin {
      openssh.authorizedKeys.keys = config.my.vars.user.sshAuthorizedKeys;
    };
  
    programs.ssh.startAgent = cfg.enableAgent;
  };}
