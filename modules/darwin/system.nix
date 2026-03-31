{
  config,
  lib,
  ...
}:
let
  cfg = config.nots.features;
  dotUsername = config.nots.username;
in
{
  options.nots.features = {
    useTouchIdSudo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable TouchID for sudo.";
    };
    useSaneSystemSettings = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sane system settings.";
    };
  };

  config = lib.mkIf cfg.useSaneSystemSettings {
    # TouchID for sudo
    security.pam.services.sudo_local.touchIdAuth = cfg.useTouchIdSudo;

    # System settings
    system = {
      primaryUser = dotUsername;
      stateVersion = 6;
      configurationRevision = config.rev or config.dirtyRev or null;

      startup.chime = true; # fun!

      defaults = {
        NSGlobalDomain = {
          AppleICUForce24HourTime = false; # use 12hr time :)
          AppleInterfaceStyleSwitchesAutomatically = true; # auto set light/dark mode
          AppleShowScrollBars = "WhenScrolling"; # when to show scroll bars
          "com.apple.sound.beep.feedback" = 0; # sound feedback when changing volume
          "com.apple.mouse.tapBehavior" = 1; # enable tap to click
        };

        ".GlobalPreferences" = {
          "com.apple.mouse.scaling" = -1.0; # disable mouse acceleration
        };

        controlcenter = {
          BatteryShowPercentage = true; # show battery % in menu bar
          AirDrop = true; # show icon in menu bar
          FocusModes = false; # hide icon in menu bar
          Bluetooth = false;
          Display = false;
          NowPlaying = false;
          Sound = false;
        };

        dock = {
          autohide = true; # autohide the dock
          magnification = true; # magnify on hover
          showhidden = true; # show hidden apps
          minimize-to-application = true; # dont minimize to separate logo
          tilesize = 40; # dock icon size (default is 48)
          largesize = 64; # dock icon size on hover (default is 16)
          mouse-over-hilite-stack = true; # highlight window grid on hover
          # persistent-apps =
          # [

          # ];
        };

        finder = {
          AppleShowAllExtensions = true; # show file ext
          AppleShowAllFiles = true; # show hidden files
          CreateDesktop = false; # hide desktop icons
          ShowPathbar = true; # show path breadcrumbs
          ShowStatusBar = true; # show status bar with item/disk stats
          _FXShowPosixPathInTitle = true; # show full POSIX fp
          _FXSortFoldersFirst = true; # keep folders on top while sorting by name
        };

        loginwindow = {
          DisableConsoleAccess = true; # disable ability to enter '>console' in login window
          GuestEnabled = false; # disable guest account creation ability
        };

        trackpad = {
          ActuationStrength = 1; # enable silent clicking
          Clicking = true; # enable tap to click
          TrackpadRightClick = true; # enable trackpad right click (vs using control)
          TrackpadThreeFingerTapGesture = 2; # look up word
        };

        CustomUserPreferences = {
          "com.apple.AppleMultitouchTrackpad" = {
            TrackpadThreeFingerHorizSwipeGesture = 0; # disable horizontal swipe
            TrackpadThreeFingerVertSwipeGesture = 2; # swipe up for mission ctrl
            # disable 4 finger stuff
            TrackpadFourFingerHorizSwipeGesture = 0;
            TrackpadFourFingerPinchGesture = 0;
            TrackpadFourFingerVertSwipeGesture = 0;
          };

          "com.apple.desktopservices" = {
            # dont create dsstore on network/usb drives
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };

          "com.apple.screensaver" = {
            # ask for passwd right after sleep/screensaver
            askForPassword = 1;
            askForPasswordDelay = 0;
          };

          "com.apple.screencapture" = {
            # screenshots default to desktop as png
            location = "~/Desktop";
            type = "png";
          };

          "com.apple.print.PrintingPrefs" = {
            # autoquit printer when done
            "Quit When Finished" = true;
          };

          "com.apple.symbolichotkeys" = {
            # disable Spotlight search (cmd + spc)
            "64" = {
              enabled = false;
              # copied from `defaults read`
              value = {
                parameters = [
                  32
                  49
                  1048576
                ];
                type = "standard";
              };
            };

            # disable spotlight window (ctrl + cmd + spc)
            "65" = {
              enabled = false;
              # copied from `defaults read`
              value = {
                parameters = [
                  32
                  49
                  1572864
                ];
                type = "standard";
              };
            };
          };
        };
      };

      # install rosetta 2
      activationScripts.extraActivation.text = ''
        softwareupdate --install-rosetta --agree-to-license
      '';
    };
  };
}
