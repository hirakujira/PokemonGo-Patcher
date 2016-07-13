// #import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSListController.h>
#import <SpringBoard/SpringBoard.h>
#import "PokemonGo_Patcher.h"

@interface PokemonGo_PatcherController: PSListController 
{
	CGRect topFrame;
	UIImageView* logoImage;
	UILabel* bannerTitle;
	UILabel* footerLabel;
	UILabel* titleLabel;
}
@property(retain) UIImageView* bannerImage;
@property(retain) UIView* bannerView;
@property(retain) NSMutableArray *translationCredits;
@end

@implementation PokemonGo_PatcherController
// - (id)specifiers {
// 	if(_specifiers == nil) {
// 		_specifiers = [[self loadSpecifiersFromPlistName:@"HandyKey" target:self] retain];
// 	}
// 	return _specifiers;
// }

- (instancetype)init {
	self = [super init];
	return self;
}

- (NSArray *)specifiers {
	if (_specifiers == nil)
    {
        NSMutableArray *specifiers = [NSMutableArray array];

        PSSpecifier *gSetFakeLocation = [PSSpecifier groupSpecifierWithName:@"Fake Location"];
        [gSetFakeLocation setProperty:@"Set your location and it will be mapped to Union Square." forKey:@"footerText"];
        [gSetFakeLocation setProperty:@(YES) forKey:@"isStaticText"];
        [specifiers addObject:gSetFakeLocation];

        PSSpecifier *initx = [PSSpecifier preferenceSpecifierNamed:@"X" target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
        [initx setIdentifier:@"_init_x"];
        [specifiers addObject:initx];

        PSSpecifier *inity = [PSSpecifier preferenceSpecifierNamed:@"Y" target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
        [inity setIdentifier:@"_init_y"];
        [specifiers addObject:inity];

        [_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:specifiers];
    }
    return _specifiers;
}


- (id)getValueForSpecifier:(PSSpecifier *)specifier {
    return getUserDefaultForKey(specifier.identifier);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier {
    system("killall pokemongo");
    setUserDefaultForKey(specifier.identifier, value);
}
@end

// vim:ft=objc
