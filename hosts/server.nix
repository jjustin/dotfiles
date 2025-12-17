{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./server-hardware.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0";

  my.vars.host = {
    server = true;
    hostName = "steve";
  };

  my.networking = {
    enableWakeOnLAN = true;
    wakeOnLanInterface = "enp3s0f0";
  };

  my.services.ssh = {
    enable = true;
    enableRootKeyLogin = true;
  };

  my.services.docker = {
    enable = true;
  };

  my.services.smb = {
    enable = true;
  };

  my.services.udev = {
    enable = true;
    rules = [
      ''ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --timeout-idle-sec=300 --collect -o \"uid=${toString config.users.users.jjustin.uid},gid=${toString config.users.groups.storage.gid},umask=002\" $devnode /run/media/jjustin/$env{ID_FS_LABEL}"''
    ];
  };

  my.services.syncthing = {
    enable = true;
    openFirewall = true;
    host = "172.17.0.1"; # expose to docker
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils # lsusb
    ghostty.terminfo
  ];
}
