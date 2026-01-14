{
  config,
  pkgs,
  lib,
  ...
}:

let
  printerDriver = (pkgs.callPackage ../derivations/dcpj100.nix { });
in
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

  my.services.printing = {
    enable = true;
    openFirewall = true;
    sharing = true;
    drivers = [
      printerDriver.driver
      printerDriver.cupswrapper
    ];
  };
  my.vars.unfreePackages = [
    (lib.getName printerDriver.driver)
    (lib.getName printerDriver.cupswrapper)
  ];
  # Workaround for brother binary requiring inf files at specific location.
  # TODO: Maybe this could be somehow achieved in the printer driver's derivation.
  systemd.tmpfiles.rules = [
    "L /opt/brother/Printers/dcpj100/inf - - - - ${printerDriver.driver}/opt/brother/Printers/dcpj100/inf"
  ];

  programs.zsh.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 6881 ]; # used by running docker service
    allowedUDPPorts = [ 6881 ]; # used by running docker service
  };

  environment.systemPackages = with pkgs; [
    usbutils # lsusb
    ghostty.terminfo
  ];
}
