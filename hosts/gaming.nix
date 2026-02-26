{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./gaming-hardware.nix
  ];

  nix.gc = {
    automatic = true;
    persistent = true;
    options = "--delete-older-than 10d";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my.vars.host.hostName = "kratos";
  my.vars.host.personal = true;

  my.obsidian = {
    enable = true;
    confirmUnfree = true;
  };

  my.services.caps2esc = {
    enable = true;
    device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  };

  my.vars.unfreePackages = [
    (lib.getName pkgs.discord)
    (lib.getName pkgs.spotify)
    (lib.getName pkgs.vscode)
    (lib.getName pkgs.steam)
    ("steam-original")
    ("steam-run")
    ("steam-unwrapped")
    (lib.getName pkgs.rar)
  ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  services.pcscd.enable = true; # yubikey

  environment.systemPackages = with pkgs; [
    brave
    # https://nixos.wiki/wiki/Discord#Screensharing_with_audio_on_wayland
    vesktop
    discord
    firefox
    ghostty
    gnome-calculator
    gnome-disk-utility
    obsidian
    oversteer # steering wheel controls
    qbittorrent
    signal-desktop
    spotify
    vscode
    vlc
    yubioath-flutter
    zed-editor
    inputs.zen-browser.packages.x86_64-linux.default

    libreoffice-qt
    hunspell # libreoffice spellchecker
    hunspellDicts.en-us
    # hunspellDicts.sl_SI // doesn't exist yet

    usbutils # lsusb
    wineWowPackages.stable
  ];
}
