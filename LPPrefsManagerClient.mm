//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "LPPrefsManagerClient.h"

@implementation LPPrefsManagerClient

-(instancetype)initWithIdentifier:(NSString *)identifier{
    if ((self = [super init])){
        _identifier = identifier;
        _messagingCenter = [CPDistributedMessagingCenter centerNamed:LOUPE_CENTER_IDENTIFIER];
        rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if (!_identifier) return;
    [self setValue:value?:[NSNull null] forKey:key identifier:_identifier];
}

-(void)setValue:(id)value forKey:(NSString *)key  identifier:(NSString *)identifier{
    [_messagingCenter sendMessageAndReceiveReplyName:@"setValue" userInfo:@{@"identifier":identifier, @"value":value, @"key":key}];
}


-(id)valueForKey:(NSString *)key{
    if (!_identifier) return nil;
    return [self valueForKey:key identifier:_identifier];
}

-(id)valueForKey:(NSString *)key identifier:(NSString *)identifier{
    id val = [_messagingCenter sendMessageAndReceiveReplyName:@"valueForKey" userInfo:@{@"identifier":identifier, @"key":key}][@"value"];
    if (val == [NSNull null] || val == nil){
        return nil;
    }
    return val;
}
@end
