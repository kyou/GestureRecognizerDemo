//
//  DoublePanGestureRecognizer.m
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-7.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import "DoublePanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation DoublePanGestureRecognizer

// called automatically by the runtime after the gesture state has been set to UIGestureRecognizerStateEnded
// any internal state should be reset to prepare for a new attempt to recognize the gesture
// after this is received all remaining active touches will be ignored (no further updates will be received for touches that had already begun but haven't ended)
- (void)reset
{
    [super reset];
    NSLog(@"%s state:%d", __FUNCTION__, self.state);
    
    self.state = UIGestureRecognizerStatePossible;
}

// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide prevention rules
// for example, a UITapGestureRecognizer never prevents another UITapGestureRecognizer with a higher tap count
//- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer;
//- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer;

// mirror of the touch-delivery methods on UIResponder
// UIGestureRecognizers aren't in the responder chain, but observe touches hit-tested to their view and their view's subviews
// UIGestureRecognizers receive touches before the view to which the touch was hit-tested
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s state:%d touch count:%d", __FUNCTION__, self.state, touches.count);
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    NSLog(@"%s state:%d touch count:%d", __FUNCTION__, self.state, touches.count);
    
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
    
    if (touches.count != 2) {
        return;
    }
    
    if (self.state == UIGestureRecognizerStatePossible &&
        [self isTouchesMovedParallel:touches])
    {
        self.state = UIGestureRecognizerStateBegan;
    }
    else if ((self.state == UIGestureRecognizerStateBegan ||
              self.state == UIGestureRecognizerStateChanged) &&
             [self isTouchesMovedParallel:touches])
    {
        self.state = UIGestureRecognizerStateChanged;
    }
    else
    {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (BOOL)isTouchesMovedParallel:(NSSet *)touches
{
    if (touches.count == 2) {
        NSArray* allTouches = [touches allObjects];
        UITouch* touch1 = [allTouches objectAtIndex:0];
        UITouch* touch2 = [allTouches objectAtIndex:1];
        
        CGPoint offset1 = [self offsetForTouch:touch1];
        CGPoint offset2 = [self offsetForTouch:touch2];
        
        if (offset1.x * offset2.x >= 0 && offset1.y * offset2.y >= 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (CGPoint)offsetForTouch:(UITouch *)touch
{
    UIWindow* window = [touch.view window];
    CGPoint location = [touch locationInView:window];
    CGPoint prevLocation = [touch previousLocationInView:window];
    CGPoint offset = CGPointMake(location.x - prevLocation.x, location.y - prevLocation.y);
    return offset;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%s state:%d", __FUNCTION__, self.state);
    
    if (self.state == UIGestureRecognizerStateChanged) {
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
