//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Common.h"
#import "Loupe.h"
#import "PrivateHeaders.h"
#import "LPMagnifier.h"
#import "LPPrefsManagerServer.h"
#import "LPPrefsManagerClient.h"

static LPMagnifier *magnifier;
static LPPrefsManagerClient *prefsClient;
static BOOL enabled;
static BOOL enabledOTextField;
static BOOL enabledOnWebView;
static BOOL forceTrackpadMagnify;
static CGFloat yOffset;
static CGFloat xOffset;
static int appsFilter;

%group LOUPE_GROUP

//Normal Text Fields
%hook UITextInteractionAssistant
-(void)rangeSelectionStarted:(CGPoint)point{
    HBLogDebug(@"rangeSelectionStarted");
    %orig;
    if (enabled && enabledOTextField){
        [magnifier beginMagnifyingTargetIfNecessary:[self valueForKey:@"_selectionView"] text:[self valueForKey:@"_view"] magnificationPoint:point offset:CGPointMake(xOffset, yOffset) animated:YES];
    }
}

-(void)rangeSelectionMoved:(CGPoint)point withTouchPoint:(CGPoint)touchPoint{
    HBLogDebug(@"rangeSelectionMoved");
    %orig;
    if (enabled && enabledOTextField){
        [magnifier beginMagnifyingTargetIfNecessary:[self valueForKey:@"_selectionView"] text:[self valueForKey:@"_view"] magnificationPoint:point offset:CGPointMake(xOffset, yOffset) animated:YES];
    }
}

-(void)rangeSelectionEnded:(CGPoint)point{
    HBLogDebug(@"rangeSelectionEnded");
    %orig;
    if (enabled && enabledOTextField){
        [magnifier stopMagnifying:YES];
    }
}

-(void)beginFloatingCursorAtPoint:(CGPoint)point{
    HBLogDebug(@"beginFloatingCursorAtPoint");
    %orig;
    if (enabled && enabledOTextField){
        [magnifier beginMagnifyingTargetIfNecessary:[self valueForKey:@"_selectionView"] text:[self valueForKey:@"_view"] magnificationPoint:point offset:CGPointMake(xOffset, yOffset) animated:YES];
    }
}

-(void)updateFloatingCursorAtPoint:(CGPoint)point velocity:(CGPoint)vel{
    HBLogDebug(@"updateFloatingCursorAtPoint");
    %orig;
    if (enabled && enabledOTextField){
        [magnifier beginMagnifyingTargetIfNecessary:[self valueForKey:@"_selectionView"] text:[self valueForKey:@"_view"] magnificationPoint:point offset:CGPointMake(xOffset, yOffset) animated:YES];
    }
}

-(void)endFloatingCursor{
    HBLogDebug(@"endFloatingCursor");
    %orig;
    if (enabled && enabledOTextField){
        [magnifier stopMagnifying:YES];
    }
}

-(void)startAutoscroll:(CGPoint)point{
    HBLogDebug(@"startAutoscroll");
    %orig;
    if (enabled && enabledOTextField && forceTrackpadMagnify){
        [magnifier beginMagnifyingTargetIfNecessary:[self valueForKey:@"_selectionView"] text:[self valueForKey:@"_view"] magnificationPoint:point offset:CGPointMake(xOffset, yOffset) animated:YES];
    }
}
%end

//WebView
%hook WKContentView
-(void)beginSelectionChange{
    HBLogDebug(@"beginSelectionChange");
    %orig;
    if (enabled && enabledOnWebView){
        [magnifier beginMagnifyingTargetIfNecessary:self text:self magnificationPoint:self.lastInteractionLocation offset:CGPointMake(xOffset, yOffset) animated:YES];
    }
}

-(void)changeSelectionWithTouchAt:(CGPoint)point withSelectionTouch:(long long)arg2 baseIsStart:(BOOL)arg3 withFlags:(long long)arg4{
    HBLogDebug(@"changeSelectionWithTouchAt");
    %orig;
    if (enabled && enabledOnWebView){
        [magnifier beginMagnifyingTargetIfNecessary:self text:self magnificationPoint:point offset:CGPointMake(xOffset, yOffset) animated:YES];
    }
}

-(void)endSelectionChange{
    HBLogDebug(@"endSelectionChange");
    %orig;
    if (enabled && enabledOnWebView){
        [magnifier stopMagnifying:YES];
    }
}
%end
%end

static void reloadPrefs(){
    if (!prefsClient){
        prefsClient = [[LPPrefsManagerClient alloc] initWithIdentifier:LOUPE_IDENTIFIER];
    }
    id enabledVal = [prefsClient valueForKey:@"enabled"];
    enabled = enabledVal ? [enabledVal boolValue] : YES;
    
    id enabledOTextFieldVal = [prefsClient valueForKey:@"enabledOTextField"];
    enabledOTextField = enabledOTextFieldVal ? [enabledOTextFieldVal boolValue] : YES;
    
    id enabledOnWebViewVal = [prefsClient valueForKey:@"enabledOnWebView"];
    enabledOnWebView = enabledOnWebViewVal ? [enabledOnWebViewVal boolValue] : YES;
    
    id forceTrackpadMagnifyVal = [prefsClient valueForKey:@"forceTrackpadMagnify"];
    forceTrackpadMagnify = forceTrackpadMagnifyVal ? [forceTrackpadMagnifyVal boolValue] : NO;
    magnifier.forceTrackpadMagnify = forceTrackpadMagnify;
    
    id yOffsetVal = [prefsClient valueForKey:@"yOffset"];
    yOffset = yOffsetVal ? [yOffsetVal floatValue] : 0.f;
    
    id xOffsetVal = [prefsClient valueForKey:@"xOffset"];
    xOffset = xOffsetVal ? [xOffsetVal floatValue] : 0.f;
    
    id appsFilterVal = [prefsClient valueForKey:@"appsFilter"];
    appsFilter = appsFilterVal ? [appsFilterVal intValue] : 0;
}

void flipLoupeEnableSwitch(BOOL enable){
    if (!prefsClient){
        prefsClient = [[LPPrefsManagerClient alloc] initWithIdentifier:LOUPE_IDENTIFIER];
    }
    [prefsClient setValue:@(enable) forKey:@"enabled"];
    enabled = enable;
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)PREFS_CHANGED_NN, NULL, NULL, YES);

}

BOOL loupeSwitchState(){
    if (prefsClient){
        id enabledVal = [prefsClient valueForKey:@"enabled"];
        return enabledVal ? [enabledVal boolValue] : YES;
    }
    return YES;
}

%ctor {
    @autoreleasepool {
        NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
        
        if (args.count != 0) {
            NSString *executablePath = args[0];
            if (executablePath) {
                NSString *processName = [executablePath lastPathComponent];
                BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
                BOOL isApplication = [executablePath rangeOfString:@"/Application"].location != NSNotFound;
                isApplication = [processName isEqualToString:@"MarkupPhotoExtension"] ?: isApplication;
                
                if (isSpringBoard){
                    [LPPrefsManagerServer sharedInstance];
                }
                
                if (isApplication){
                    //Actually, Apple disabled this functionality using the YukonMagnifiersDisabled key. But enabled this will brings lot more problems than solving it (caret not properly released and freezed after magnified etc.). Let's not do that, i.e.
                    //UIKeyboardPreferencesController *kbPrefsController = [%c(UIKeyboardPreferencesController) sharedPreferencesController];
                    //[kbPrefsController.preferencesActions setValue:@NO forPreferenceKey:@"YukonMagnifiersDisabled"];
                    //HBLogDebug(@"YukonMagnifiersDisabled: %d", [kbPrefsController boolForPreferenceKey:@"YukonMagnifiersDisabled"]?1:0);
                    magnifier = [LPMagnifier sharedInstance];
                    reloadPrefs();
                    
                    NSArray *filteredApps = [prefsClient valueForKey:@"filteredApps"];
                    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
                    BOOL shouldLoadTweak = (appsFilter == 0 && ![filteredApps containsObject:bundleIdentifier]) || (appsFilter != 0 && [filteredApps containsObject:bundleIdentifier]);
                    
                    if (shouldLoadTweak){
                        magnifier.async = YES;
                        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, (CFStringRef)PREFS_CHANGED_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
                        %init(LOUPE_GROUP)
                    }else{
                        magnifier = nil;
                    }
                }
            }
        }
    }
}
