//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "LPPrefsManagerServer.h"

@implementation LPPrefsManagerServer

+(instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    __strong static LPPrefsManagerServer *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _messagingCenter = [CPDistributedMessagingCenter centerNamed:LOUPE_CENTER_IDENTIFIER];
        rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);
        
        [_messagingCenter runServerOnCurrentThread];
        [_messagingCenter registerForMessageName:@"setValue" target:self selector:@selector(setValue:withUserInfo:)];
        [_messagingCenter registerForMessageName:@"valueForKey" target:self selector:@selector(valueForKey:withUserInfo:)];
    }
    
    return self;
}

-(NSDictionary *)setValue:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
    [self setValue:userInfo[@"value"]?:nil forKey:userInfo[@"key"] identifier:userInfo[@"identifier"]];
    return nil;
}

-(void)setValue:(id)value forKey:(NSString *)key identifier:(NSString *)identifier{
    CFStringRef appID = (__bridge CFStringRef)identifier;
    CFPreferencesSetAppValue((__bridge CFStringRef)key, value ? (__bridge CFPropertyListRef)value : NULL, appID);
    CFPreferencesAppSynchronize(appID);
}

-(NSDictionary *)valueForKey:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
    id val = [self valueForKey:userInfo[@"key"] identifier:userInfo[@"identifier"]];
    if (val == [NSNull null] || val == nil){
        return @{@"value":[NSNull null]};

    }
    return @{@"value":val};
}

-(id)valueForKey:(NSString *)key identifier:(NSString *)identifier{
    CFStringRef appID = (__bridge CFStringRef)identifier;
    CFPreferencesAppSynchronize(appID);
    
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (keyList != NULL){
        BOOL containsKey = CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), (__bridge CFStringRef)key);
        CFRelease(keyList);
        if (!containsKey) return nil;
        return CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key, appID));
    }
    return nil;
}

@end
