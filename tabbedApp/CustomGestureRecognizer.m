//
//  CustomGestureRecognizer.m
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-5.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import "CustomGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CustomGestureRecognizer
{
    BOOL strokeUp_;
    CGPoint midPoint_;
}

// the following methods are to be overridden by subclasses of UIGestureRecognizer
// if you override one you must call super

// called automatically by the runtime after the gesture state has been set to UIGestureRecognizerStateEnded
// any internal state should be reset to prepare for a new attempt to recognize the gesture
// after this is received all remaining active touches will be ignored (no further updates will be received for touches that had already begun but haven't ended)
- (void)reset
{
    [super reset];
    NSLog(@"%s state:%d", __FUNCTION__, self.state);
    
    midPoint_ = CGPointZero;
    strokeUp_ = NO;
}

// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide prevention rules
// for example, a UITapGestureRecognizer never prevents another UITapGestureRecognizer with a higher tap count
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    NSLog(@"%s preventedGestureRecognizer:%@", __FUNCTION__, NSStringFromClass([preventedGestureRecognizer class]));
    if ([preventedGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

/*
// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide prevention rules
// for example, a UITapGestureRecognizer never prevents another UITapGestureRecognizer with a higher tap count
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer;
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer;
*/

// mirror of the touch-delivery methods on UIResponder
// UIGestureRecognizers aren't in the responder chain, but observe touches hit-tested to their view and their view's subviews
// UIGestureRecognizers receive touches before the view to which the touch was hit-tested
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s state:%d", __FUNCTION__, self.state);
    
    if (touches.count != 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    NSLog(@"%s state:%d", __FUNCTION__, self.state);
    
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
    
//    UIWindow* window = self.view.window;
//    CGPoint nowPoint = [touches.anyObject locationInView:window];
    CGPoint nowPoint = [touches.anyObject locationInView:self.view];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];
    
    if (!strokeUp_) {
        // downstroke, both x and y increase in positive direction
        if (nowPoint.x >= prevPoint.x && nowPoint.y >= prevPoint.y) {
            midPoint_ = nowPoint;
        }
        // upstroke, increase x but decrease y
        else if (midPoint_.x != 0 && midPoint_.y != 0 &&
                 nowPoint.x >= midPoint_.x && nowPoint.y <= midPoint_.y) {
            strokeUp_ = YES;
        }
        else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s state:%d", __FUNCTION__, self.state);
    
    if (self.state == UIGestureRecognizerStatePossible && strokeUp_) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"%s state:%d", __FUNCTION__, self.state);
    
    self.state = UIGestureRecognizerStateFailed;

}

@end
