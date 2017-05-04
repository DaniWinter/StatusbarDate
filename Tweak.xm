NSDateFormatter *format = [[NSDateFormatter alloc] init];
NSDate *date = [NSDate date];
NSString *Format = @"MM-dd-yyyy";
NSString *timeLocation = @"1";
BOOL Enabled = YES;
BOOL timeEnabled = NO;

%hook SBStatusBarStateAggregator
-(void)_updateTimeItems {
  if (Enabled) {
    if (timeEnabled) {
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
    MSHookIvar<NSDateFormatter *>(self, "_timeItemDateFormatter") = format;
    date = nil;
  }
  %orig;
}
%end

static void loadPrefs() {
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
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("nl.d4ni.statusbardateprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}
