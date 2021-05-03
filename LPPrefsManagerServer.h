//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Common.h"
#import <RocketBootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

@interface LPPrefsManagerServer : NSObject{
    CPDistributedMessagingCenter * _messagingCenter;
}
+(instancetype)sharedInstance;
@end
