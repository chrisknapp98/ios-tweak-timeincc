#include "TICRootListController.h"

NSString *bundleID = @"com.chrisknapp.timeinccpreferences";   

@implementation TICRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)openNSDateFormatterSite {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://nsdateformatter.com"]
	options:@{}
	completionHandler:nil];
}

- (void)respring {
	[HBRespringController respring];
}

/* 
- (void)resetPreferences {
    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier:bundleID];
    [preferences removeAllObjects];
	[self respring];
} 
*/


@end
