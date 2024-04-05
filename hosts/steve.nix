{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./steve-hardware.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0";

  my.networking = {
    hostName = "steve";
    enableWakeOnLAN = true;
    wakeOnLanInterface = "enp5s0";
  };

  my.services.plex = {
    enable = true;
    confirmUnfree = true;
  };

  my.services.qbittorrent = {
    enable = true;
    openFirewall = true;
  };

  my.services.ssh = {
    enable = true;
    enableRootKeyLogin = true;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils # lsusb
  ];

  myvars.user.sshAuthorizedKeys = [
    config.myvars.sshKey
  ];
}
