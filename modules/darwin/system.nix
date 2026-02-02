{ lib, config, ... }:
let
  ifPersonal = application: lib.optional config.my.vars.host.personal application;
  ifWork = application: lib.optional config.my.vars.host.work application;
in
{
  system = {
    defaults = {
      NSGlobalDomain."com.apple.keyboard.fnState" = true; # use f1, f2,... as f keys
      NSGlobalDomain."com.apple.sound.beep.feedback" = 1; # beep when adjusting sound
      NSGlobalDomain."com.apple.swipescrolldirection" = false; # no natural scrolling
      ".GlobalPreferences"."com.apple.mouse.scaling" = 0.875; # Set tracking speed
      CustomSystemPreferences.NSGlobalDomain."com.apple.mouse.linear" = true; # Disable pointer acceleration, this once can probably be moved to built-in property (like the aboves): https://github.com/LnL7/nix-darwin/pull/1037

      controlcenter = {
        BatteryShowPercentage = true;
        Bluetooth = true;
        Sound = true;
      };

      dock = {
        show-recents = false;
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        tilesize = 32;
        launchanim = false;
        magnification = false;
        orientation = "left";
        # Flatten because ifWork and ifPersonal produce a list
        persistent-apps = lib.lists.flatten [
          "/Applications/Brave Browser.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Ghostty.app"
          "/Applications/Bruno.app"
          "/Applications/Obsidian.app"
          (ifWork "/Applications/Slack.app")
          "/Applications/Discord.app"
          "/Applications/Signal.app"
          "/Applications/Spotify.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/System Settings.app"
          (ifPersonal "/Applications/Whisky.app")
          (ifPersonal "/Applications/Steam.app")
        ];
        showAppExposeGestureEnabled = true; # 3 or 4-finger swipe up
        showDesktopGestureEnabled = true; # 4-finger spread to show desktop
        showLaunchpadGestureEnabled = true; # 4-finger pinch to show desktop
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXPreferredViewStyle = "clmv"; # Column view
        _FXEnableColumnAutoSizing = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      trackpad = {
        ActuationStrength = 0; # silent clicking
        FirstClickThreshold = 0; # light clicking
      };
    };
  };

  power.sleep = {
    computer = 30; # minutes
    display = 10; # minutes
  };
}
