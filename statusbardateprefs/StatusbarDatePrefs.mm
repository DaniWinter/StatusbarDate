#import <Preferences/Preferences.h>
#include <spawn.h>
#include <signal.h>

@interface StatusbarDatePrefsListController: PSListController {
}
@end

@implementation StatusbarDatePrefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"StatusbarDatePrefs" target:self] retain];
	}
	return _specifiers;
}

-(void)save {
	pid_t pid;
	int status;
	const char *argv2[] = {"killall", "SpringBoard", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv2, NULL);
	waitpid(pid, &status, WEXITED);
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
