NSString *Format = @"MM-dd-yyyy";
NSString *timeLocation = @"1";
BOOL Enabled = YES;
BOOL timeEnabled = NO;
BOOL debugging = NO;

%hook SBStatusBarStateAggregator
-(void)_updateTimeItems {

  if (debugging) {
    NSLog(@"StatusbarDate: ENABLED: %d", Enabled);
  }

  NSDateFormatter *format = [[NSDateFormatter alloc] init];

  if (Enabled) {
    if (debugging) {
      NSLog(@"StatusbarDate: TIME ENABLED: %d", timeEnabled);
    }

    if (timeEnabled) {
      if (debugging) {
        NSLog(@"StatusbarDate: TIME LOCATION: %@", timeLocation);
      }

      if ([timeLocation isEqualToString:@"1"]) {
        [format setDateFormat:[NSString stringWithFormat:@"HH:mm - %@", Format]];
      }
      else {
        [format setDateFormat:[NSString stringWithFormat:@"%@ - HH:mm", Format]];
      }
    }
    else {
      [format setDateFormat:[NSString stringWithFormat:@"%@", Format]];
    }

    if (debugging) {
      NSLog(@"StatusbarDate: UPDATE TIME");
    }

    MSHookIvar<NSDateFormatter *>(self, "_timeItemDateFormatter") = format;
  }
  %orig;
}
%end

static void loadPrefs() {
  if (debugging) {
    NSLog(@"StatusbarDate: Loading preferences..");
  }

  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/nl.d4ni.statusbardateprefs.plist"];

  if(prefs) {
    Enabled = ( [prefs objectForKey:@"kEnabled"] ? [[prefs objectForKey:@"kEnabled"] boolValue] : Enabled );
    timeEnabled = ( [prefs objectForKey:@"timeEnabled"] ? [[prefs objectForKey:@"timeEnabled"] boolValue] : timeEnabled );
    Format = [prefs valueForKey:@"dateFormat"];
    timeLocation = [prefs valueForKey:@"timeLocation"];
  }
  [prefs release];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("nl.d4ni.plsnoresetprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}
