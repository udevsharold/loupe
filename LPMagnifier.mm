//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "LPMagnifier.h"

@implementation LPMagnifier

+(instancetype)sharedInstance{
    static dispatch_once_t once = 0;
    __strong static LPMagnifier *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

-(instancetype)init{
    if ((self = [super init])){
        _loupe = [[objc_getClass("UITextMagnifierCaret") alloc] initWithFrame];
    }
    return self;
}

-(BOOL)isTrackpadMode{
    if (_magnifying){
        return NO;
    }else{
        return [[objc_getClass("UIKeyboardImpl") activeInstance] isTrackpadMode];
    }
}

-(void)beginMagnifyingTargetIfNecessary:(UIView *)target text:(UIResponder *)text magnificationPoint:(CGPoint)point offset:(CGPoint)offset animated:(BOOL)animated{
    
    void (^codeBlock)() = ^{
        if (self.forceTrackpadMagnify || ![self isTrackpadMode]){
            if (_loupe.target){
                _loupe.magnificationPoint = point;
            }else{
                _magnifying = YES;
                [_loupe beginMagnifyingTarget:target text:text magnificationPoint:point offset:offset animated:animated];
            }
        }
    };
    
    if (self.async){
        dispatch_async(dispatch_get_main_queue(), codeBlock);
    }else{
        codeBlock();
    }
}

-(void)stopMagnifying:(BOOL)stop{
    void (^codeBlock)() = ^{
        _magnifying = NO;
        [_loupe stopMagnifying:stop];
    };
    
    if (self.async){
        dispatch_async(dispatch_get_main_queue(), codeBlock);
    }else{
        codeBlock();
    }
}

@end
