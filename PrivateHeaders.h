//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Common.h"

@protocol UITextInputPrivate
@end

@interface UITextSelectionView : UIView
@end

@interface UITextMagnifier : UIView
@property (nonatomic,retain) UIView * target;
@property (nonatomic,retain) UIResponder<UITextInput>* text;
@property (assign,nonatomic) CGPoint magnificationPoint;
@property (assign,nonatomic) CGPoint animationPoint;
@property (nonatomic,readonly) CGPoint terminalPoint;
@property (nonatomic,readonly) BOOL terminalPointPlacedCarefully;
@property (nonatomic,readonly) BOOL isHorizontal;
@property (nonatomic,readonly) double offsetFromMagnificationPoint;
+(Class)renderClass;
-(void)setNeedsDisplay;
-(UIResponder<UITextInput>*)text;
-(void)setText:(UIResponder<UITextInput>*)arg1 ;
-(UIView *)target;
-(void)setTarget:(UIView *)arg1 ;
-(id)initWithFrame:(CGRect)arg1 ;
-(CGPoint)terminalPoint;
-(CGPoint)animationPoint;
-(void)remove;
-(void)stopMagnifying:(BOOL)arg1 ;
-(void)beginMagnifyingTarget:(id)arg1 text:(id)arg2 magnificationPoint:(CGPoint)arg3 offset:(CGPoint)arg4 animated:(BOOL)arg5 ;
-(void)setMagnificationPoint:(CGPoint)arg1 ;
-(void)zoomDownAnimation;
-(CGPoint)adjustMagnificationPoint:(CGPoint)arg1 ;
-(void)updateFrameAndOffset;
-(void)setToMagnifierRenderer;
-(void)animateToMagnifierRenderer;
-(void)animateToAutoscrollRenderer;
-(void)zoomUpAnimation;
-(void)detectLostTouches:(id)arg1 ;
-(void)windowWillRotate:(id)arg1 ;
-(CGPoint)magnificationPoint;
-(BOOL)terminalPointPlacedCarefully;
-(void)postAutoscrollPoint:(CGPoint)arg1 ;
-(void)autoscrollWillNotStart;
-(void)setAutoscrollDirections:(int)arg1 ;
-(void)beginZoomUpAnimation:(/*^block*/id)arg1 withDuration:(double)arg2 ;
-(void)beginZoomDownAnimation:(/*^block*/id)arg1 withDuration:(double)arg2 postponeHandler:(/*^block*/id)arg3 ;
-(void)setAnimationPoint:(CGPoint)arg1 ;
-(double)offsetFromMagnificationPoint;
-(void)setFrame:(CGRect)arg1 ;
-(BOOL)isHorizontal;
@end

@interface UITextMagnifierCaret : UITextMagnifier
@property (assign,nonatomic) CGPoint offset;
+(Class)renderClass;
+(id)sharedCaretMagnifier;
+(id)activeCaretMagnifier;
-(CGPoint)offset;
-(void)setOffset:(CGPoint)arg1 ;
-(id)initWithFrame;
-(CGPoint)animationPoint;
-(void)remove;
-(void)beginMagnifyingTarget:(id)arg1 text:(id)arg2 magnificationPoint:(CGPoint)arg3 offset:(CGPoint)arg4 animated:(BOOL)arg5 ;
-(void)zoomDownAnimation;
-(void)updateFrameAndOffset;
-(void)zoomUpAnimation;
-(BOOL)terminalPointPlacedCarefully;
-(void)setAnimationPoint:(CGPoint)arg1 ;
-(double)offsetFromMagnificationPoint;
-(BOOL)isHorizontal;
@end

@interface UITextInteractionAssistant : NSObject{
    UIResponder<UITextInput> *_view;
    UITextSelectionView* _selectionView;
}
@end

@interface UIKeyboardImpl : UIView
+(id)sharedInstance;
+(id)activeInstance;
-(BOOL)isTrackpadMode;
@end


@interface WKWebView : UIView
@end

@interface WKApplicationStateTrackingView : UIView
@end

@interface WKContentView : WKApplicationStateTrackingView
@property (nonatomic,readonly) CGPoint lastInteractionLocation;
-(WKWebView *)webView;
@end

@interface _UIKeyboardTextSelectionController : NSObject
@property (nonatomic,readonly) UIResponder<UITextInput> *inputDelegate;
@property (nonatomic,readonly) UIView * textInputView;
@property (nonatomic,readonly) UITextInteractionAssistant * interactionAssistant;
@end

@interface _UIKeyboardAsyncTextSelectionController : _UIKeyboardTextSelectionController
@end

@protocol TIPreferencesControllerActions <NSObject>
@end

@interface UIKeyboardPreferencesController : NSObject
@property (nonatomic,readonly) UIKeyboardPreferencesController <TIPreferencesControllerActions>* preferencesActions;
+(id)sharedPreferencesController;
+(id)valueForPreferenceKey:(id)arg1 domain:(id)arg2 ;
-(BOOL)boolForPreferenceKey:(id)arg1 ;
-(void)setValue:(id)arg1 forPreferenceKey:(id)arg2 ;
@end
