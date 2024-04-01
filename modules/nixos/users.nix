{ config, pkgs, lib, ... }:

{
  users.groups.storage = {
    gid = 1012;
  };

  users.users.${config.myvars.user.username} = {
    isNormalUser = true;
    password = "changeme!";
    description = config.myvars.user.fullName;
    extraGroups = [ "networkmanager" "wheel" "storage" ];
    uid = 1000;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.myvars.user.sshAuthorizedKeys;
  };
}
