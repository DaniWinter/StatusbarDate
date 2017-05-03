NSDateFormatter *date;
NSString *Format = @"MM-dd-yyyy";
static BOOL Enabled = YES;

%hook SBStatusBarStateAggregator
-(void)_updateTimeItems {
  if (Enabled) {
    date = [[NSDateFormatter alloc] init];
    [date setTimeStyle:NSDateFormatterNoStyle];
    [date setDateFormat:Format];
    NSString *returnDate = [date stringFromDate:[NSDate date]];
    [date setDateFormat:[NSString stringWithFormat:@"'%@'",returnDate]];
    MSHookIvar<NSDateFormatter *>(self, "_timeItemDateFormatter") = date;
    date = nil;
  }
  %orig;
}
%end

static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/nl.d4ni.statusbardateprefs.plist"];
  if(prefs) {
    Enabled = ( [prefs objectForKey:@"kEnabled"] ? [[prefs objectForKey:@"kEnabled"] boolValue] : Enabled );
    Format = [prefs valueForKey:@"dateFormat"];
    NSLog(@"FORMAT: %@", Format);
  }
  [prefs release];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("nl.d4ni.statusbardateprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}
