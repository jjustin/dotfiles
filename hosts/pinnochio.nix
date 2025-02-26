{
  config,
  pkgs,
  lib,
  ...
}:

{

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  my.networking.hostName = "pinnochio";

  my.services.ssh = {
    enable = true;
    enableRootKeyLogin = false;
  };

  myvars.user.sshAuthorizedKeys = [
    config.myvars.sshKey
  ];

  my.services.postgres = {
    enable = true;
  };
}
