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

  my.services.caddy = {
    enable = true;
    openFirewall = true;
  };


  my.services.plex = {
    enable = true;
    confirmUnfree = true;
  };

  my.services.qbittorrent = {
    enable = true;
  };

  my.services.ssh = {
    enable = true;
    enableRootKeyLogin = true;
  };

  my.services.docker = {
    enable = true;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils # lsusb
  ];
}
