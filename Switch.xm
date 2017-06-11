#import <Flipswitch/FSSwitchDataSource.h>
#import <Flipswitch/FSSwitchPanel.h>
#import "../../PS.h"

CFStringRef key = CFSTR("_SBAllowHomeButtonTimer");
CFStringRef kSpringBoard = CFSTR("com.apple.springboard");

@interface HomeButtonTimerSwitch : NSObject <FSSwitchDataSource>
@end

@implementation HomeButtonTimerSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
    Boolean keyExist;
    Boolean enabled = CFPreferencesGetAppBooleanValue(key, kSpringBoard, &keyExist);
    if (!keyExist)
        return FSSwitchStateOn;
    return enabled ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
    if (newState == FSSwitchStateIndeterminate)
        return;
    CFBooleanRef enabled = newState == FSSwitchStateOn ? kCFBooleanTrue : kCFBooleanFalse;
    CFPreferencesSetAppValue(key, enabled, kSpringBoard);
    CFPreferencesAppSynchronize(kSpringBoard);
}

@end

%group iOS10Up

%hook SBHomeHardwareButton

- (BOOL)_isMenuDoublePressAllowed: (id)arg1 {
    BOOL orig = %orig;
    return orig ? [[FSSwitchPanel sharedPanel] stateForSwitchIdentifier:@"com.PS.HomeButtonTimer"] == FSSwitchStateOn : orig;
}

%end

%end

%group preiOS10

%hook SpringBoard

- (BOOL)isMenuDoubleTapAllowed {
    BOOL orig = %orig;
    return orig ? [[FSSwitchPanel sharedPanel] stateForSwitchIdentifier:@"com.PS.HomeButtonTimer"] == FSSwitchStateOn : orig;
}

%end

%end

%ctor {
    if (isiOS10Up) {
        %init(iOS10Up);
    } else {
        %init(preiOS10);
    }
}
