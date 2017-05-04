#import <Preferences/Preferences.h>
#include <spawn.h>
#include <signal.h>

@interface StatusbarDatePrefsListController: PSListController {
}
@end

@implementation StatusbarDatePrefsListController

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:path];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"StatusbarDatePrefs" target:self] retain];
	}
	return _specifiers;
}

-(void)save {
	// [self showMessage:@"Device will respring in 5 seconds."
  //                   withTitle:@"Saving.."];
	// double delayInSeconds = 7.0;
	// dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	// dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		pid_t pid;
		int status;
		const char *argv2[] = {"killall", "SpringBoard", NULL};
		posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv2, NULL);
		waitpid(pid, &status, WEXITED);
	// });
}

-(void)showMessage:(NSString*)message withTitle:(NSString *)title{
	dispatch_async(dispatch_get_main_queue(), ^{
	    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	    // [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			//
	    // }]];

	    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:^{
	    }];
	});
}

- (void)donate {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/DaniWinter"]];
}
- (void)contact {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:mail@d4ni.nl?subject=StatusbarDate"]];
}
- (void)follow {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.twitter.com/GewoonDani"]];
}
- (void)github {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/DaniWinter/StatusbarDate"]];
}
@end

// vim:ft=objc
