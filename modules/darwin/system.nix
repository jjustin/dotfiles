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
          "/Applications/Obsidian.app"
          (ifWork "/Applications/Slack.app")
          "/Applications/Discord.app"
          "/Applications/Signal.app"
          "/Applications/Spotify.app"
          "/System/Applications/Calendar.app"
          (ifPersonal "/System/Applications/Photos.app")
          "/System/Applications/System Settings.app"
          (ifPersonal "/Applications/Whisky.app")
        ];
      };

      finder = {
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      trackpad = {
        ActuationStrength = 0; # silent clicking
        FirstClickThreshold = 0; # light clicking

      };
    };
  };
}
