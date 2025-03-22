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
    enable = mkEnableOption "ssh";
    enableRootKeyLogin = mkEnableOption "root key login";
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;

    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.settings.PermitRootLogin = "without-password";
    users.users.root = lib.mkIf cfg.enableRootKeyLogin {
      openssh.authorizedKeys.keys = config.my.vars.user.sshAuthorizedKeys;
    };
  };
}
