//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Common.h"
#import "PrivateHeaders.h"

@interface LPMagnifier : NSObject{
    UITextMagnifierCaret *_loupe;
    BOOL _magnifying;
}
@property (nonatomic, assign) BOOL async;
@property (nonatomic, assign) BOOL forceTrackpadMagnify;
+(instancetype)sharedInstance;
-(void)beginMagnifyingTargetIfNecessary:(UIView *)target text:(UIResponder *)text magnificationPoint:(CGPoint)point offset:(CGPoint)offset animated:(BOOL)animated;
-(void)stopMagnifying:(BOOL)stop;
@end
