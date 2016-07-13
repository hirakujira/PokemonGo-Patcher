#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include <stdio.h>
#include <sys/sysctl.h>
#include <sys/stat.h>
#include <objc/runtime.h>

%hook NSFileManager
- (BOOL)fileExistsAtPath:(NSString *)path
{
    // %log;
    if ([path isEqualToString:@"/Applications/Cydia.app"] ||
        [path isEqualToString:@"/Applications/blackra1n.app"] ||
        [path isEqualToString:@"/Applications/FakeCarrier.app"] ||
        [path isEqualToString:@"/Applications/Iny.app"] ||
        [path isEqualToString:@"/Applications/IntelliScreen.app"] ||
        [path isEqualToString:@"/Applications/MxTube.app"] ||
        [path isEqualToString:@"/Applications/RockApp.app"] ||
        [path isEqualToString:@"/Applications/SBSettings.app"] ||
        [path isEqualToString:@"/Applications/WinterBoard.app"] ||
        [path isEqualToString:@"/private/var/tmp/cydia.log"] ||
        [path isEqualToString:@"/usr/binsshd"] ||
        [path isEqualToString:@"/usr/sbinsshd"] ||
        [path isEqualToString:@"/usr/libexec/sftp-server"] ||
        [path isEqualToString:@"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"] ||
        [path isEqualToString:@"/Library/MobileSubstrateMobileSubstrate.dylib"] ||
        [path isEqualToString:@"/var/log/syslog"] ||
        [path isEqualToString:@"/bin/bash"] ||
        [path isEqualToString:@"/bin/sh"] ||
        [path isEqualToString:@"/etc/ssh/sshd_config"] ||
        [path isEqualToString:@"/usr/libexec/ssh-keysign"]) {
        return NO;
    }
    //Lacking of slashes? Yes, that's what they 'detect' in the app. lol
    return %orig;
}
%end

%hook UIApplication 
- (BOOL)canOpenURL:(NSURL *)url {
    return [[url absoluteString] isEqualToString:@"cydia://"] ? NO : %orig;
}
%end


%hook CLLocation

static float x = -1;
static float y = -1;
static NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/tw.hiraku.pokemongo.plist"];

- (CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D position = %orig;

    if (x == -1 && y == -1) {
        float init_x = plistDict[@"_init_x"] ? [plistDict[@"_init_x"] floatValue] : 37.7883923;
        float init_y = plistDict[@"_init_y"] ? [plistDict[@"_init_y"] floatValue] : -122.4076413;
        init_x = init_x > 90 ? 90 : init_x;
        init_x = init_x < -90 ? -90 : init_x;
        init_y = init_y > 180 ? 180 : init_y;
        init_y = init_y < -180 ? -180 : init_y;
        x = position.latitude - init_x;
        y = position.longitude - init_y;
        plistDict[@"_offset_x"] = [NSNumber numberWithFloat:x];
        plistDict[@"_offset_y"] = [NSNumber numberWithFloat:y];
        [plistDict writeToFile:@"/var/mobile/Library/Preferences/tw.hiraku.pokemongo.plist" atomically:NO];
    }
    return CLLocationCoordinate2DMake(position.latitude-x, position.longitude-y);
}
%end


//Implement printf to print logs...
int printf(const char * __restrict format, ...)
{ 
    va_list args;
    va_start(args,format);    
    NSLogv([NSString stringWithUTF8String:format], args) ;    
    va_end(args);
    return 1;
}

static FILE * (*orig_fopen) ( const char * filename, const char * mode );
FILE * new_fopen ( const char * filename, const char * mode ) {
    if (strcmp(filename, "/bin/bash") == 0) {
        return NULL;
    }
    return orig_fopen(filename, mode);
}

static int (*orig_stat)(const char * file_name, struct stat *buf);
int new_stat(const char * file_name, struct stat *buf) {
    if (strcmp(file_name, "/Library/Frameworks/CydiaSubstrate.framework") == 0) {  
        return -1;
    }
    return orig_stat(file_name, buf);
}

static int (*orig_lstat)(const char *path, struct stat *buf);
int new_lstat(const char *path, struct stat *buf) {
    if (strcmp(path, "/Applications") == 0) {
        return -1;
    }
    return orig_lstat(path, buf);
}

%ctor {

    if(![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/tw.hiraku.pokemongo.plist"]) { 
        NSDictionary *plistDict = @{@"_init_x":@37.7883923,@"_init_y":@-122.4076413};
        [plistDict writeToFile:@"/var/mobile/Library/Preferences/tw.hiraku.pokemongo.plist" atomically:NO];
    }
    
    if (plistDict[@"_offset_x"]) {
        x = [plistDict[@"_offset_x"] floatValue];
    };
    
    if (plistDict[@"_offset_y"]) {
        x = [plistDict[@"_offset_y"] floatValue];
    };

    %init;
    MSHookFunction((void *)fopen, (void *)new_fopen, (void **)&orig_fopen);
    MSHookFunction((void *)stat, (void *)new_stat, (void **)&orig_stat);
    MSHookFunction((void *)lstat, (void *)new_lstat, (void **)&orig_lstat);
}
