//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Common.h"
#import <RocketBootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

@interface LPPrefsManagerClient : NSObject{
    NSString *_identifier;
    CPDistributedMessagingCenter * _messagingCenter;
}
-(instancetype)initWithIdentifier:(NSString *)identifier;
-(void)setValue:(id)value forKey:(NSString *)key;
-(id)valueForKey:(NSString *)key;
@end
