{ ... }:
{
  system = {
    defaults = {
      NSGlobalDomain."com.apple.keyboard.fnState" = true; # use f1, f2,... as f keys
      NSGlobalDomain."com.apple.sound.beep.feedback" = 1; # beep when adjusting sound
      NSGlobalDomain."com.apple.swipescrolldirection" = false; # no natural scrolling

      dock = {
        show-recents = false;
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        tilesize = 32;
        launchanim = false;
        magnification = false;
        orientation = "left";
        persistent-apps = [
          "/Applications/Brave Browser.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/iTerm.app"
          "/Applications/Obsidian.app"
          "/Applications/Slack.app"
          "/Applications/Discord.app"
          "/Applications/Signal.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/System Settings.app"
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
