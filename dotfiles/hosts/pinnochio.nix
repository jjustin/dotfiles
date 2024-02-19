{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./pinnochio-hardware.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my.networking.hostName = "pinnochio";

  my.services.plex = {
    enable = true;
    confirmUnfree = true;
  };

  my.obsidian = {
    enable = true;
    confirmUnfree = true;
  };

  my.services.caps2esc =
    {
      enable = true;
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    };

  myvars.unfreePackages =
    [
      (lib.getName pkgs.discord)
      (lib.getName pkgs.spotify)
      (lib.getName pkgs.vscode)
      (lib.getName pkgs.steam)
      ("steam-original")
      ("steam-run")
    ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) config.myvars.unfreePackages;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.steam.enable = true;
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  environment.variables.EDITOR = "nvim";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    987 # chiaki
    9295 # chiaki
  ];
  networking.firewall.allowedUDPPorts = [
    987 # chiaki
    9295 # chiaki
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
