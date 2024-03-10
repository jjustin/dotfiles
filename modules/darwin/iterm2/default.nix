{ lib, ... }:

{
  # SHould this be: CustomSystemPreferences

  system.defaults.CustomUserPreferences =
    {
      "com.googlecode.iterm2.plist" = {
        PrefsCustomFolder = builtins.toString ./.; # the config file should be located in the directory
        LoadPrefsFromCustomFolder = 1;
      };
    };
}
