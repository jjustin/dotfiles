{
  config,
  pkgs,
  lib,
  ...
}:

{
  users.groups.storage = {
    gid = 1012;
  };

  users.users.${config.my.vars.user.username} = {
    isNormalUser = true;
    password = "changeme!";
    description = config.my.vars.user.fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
      "storage"
    ];
    uid = 1000;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.my.vars.user.sshAuthorizedKeys;
  };
}
