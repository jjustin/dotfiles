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

  my.networking.hostName = "steve";

  my.services.plex = {
    enable = true;
    confirmUnfree = true;
  };

  my.services.ssh.enable = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils # lsusb
  ];

  myvars.user.sshAuthorizedKeys = [
    config.myvars.sshKey
  ];
}
