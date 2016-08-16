#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
// #import <Preferences/Preferences.h>

#define PreferenceBundlePath @"/Library/PreferenceBundles/PokemonGo_Patcher.bundle"
#define SettingPath @"/var/mobile/Library/Preferences/tw.hiraku.pokemongo.plist"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define iKeywiColor UIColorFromRGB(0xFAAB26)
#define iPhone6  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.width == 414.0

static CGFloat const kHBFPHeaderTopInset = 64.f;
static CGFloat const kHBFPHeaderHeight = 150.f;
//====================================================================================================================

@interface PSSpecifier (iKeywi)
- (void)setIdentifier:(NSString *)identifier;
@end

@interface PSListController (iKeywi)
- (void)loadView;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface PSTableCell (iKeywi)
@property(readonly, assign, nonatomic) UILabel* textLabel;
@end

//====================================================================================================================

id getUserDefaultForKey(NSString *key) {
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:SettingPath];
    return [defaults objectForKey:key];
}

void setUserDefaultForKey(NSString *key, id value) {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:SettingPath]];
    [defaults setObject:value forKey:key];

	if (![key isEqualToString:@"setJapanese"] && ![key isEqualToString:@"showOrigImageInPokePP"]) {
		[defaults removeObjectForKey:@"_offset_x"];
		[defaults removeObjectForKey:@"_offset_y"];
		[defaults setObject:@YES forKey:@"apply"];
	}
	
    [defaults writeToFile:SettingPath atomically:YES];
}