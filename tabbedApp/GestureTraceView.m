//
//  GestureTraceView.m
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-7.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import "GestureTraceView.h"

@implementation GestureTraceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _touches = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
//    UIBezierPath* path = [self pathOfAllTouches];
    UIBezierPath* path = [self smoothPathOfAllTouches];
    [path stroke];
    
    CGContextRestoreGState(context);
/*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    [self.touches enumerateObjectsUsingBlock:^(NSValue* touch, NSUInteger idx, BOOL *stop) {
        CGPoint location = [touch CGPointValue];
        NSLog(@"add location:%@", NSStringFromCGPoint(location));
        if (idx == 0) {
            CGPathMoveToPoint(path, NULL, location.x, location.y);
        } else {
            CGPathAddLineToPoint(path, NULL, location.x, location.y);
        }
    }];
    
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 5.0f);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextStrokePath(context);
    CFRelease(path);
    
    CGContextRestoreGState(context);
*/
}

- (UIBezierPath *)pathOfAllTouches
{
    if ([self.touches count] <= 0) {
        return nil;
    }
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 5.0f;
    
    [self.touches enumerateObjectsUsingBlock:^(NSValue* touch, NSUInteger idx, BOOL *stop) {
        CGPoint location = [touch CGPointValue];
        if (idx == 0) {
            [path moveToPoint:location];
        } else {
            [path addLineToPoint:location];
        }
    }];
    
    return path;
}


- (UIBezierPath *)smoothPathOfAllTouches
{
    if ([self.touches count] <= 0) {
        return nil;
    }
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 5.0f;
    
    CGPoint firstLocation = [[self.touches objectAtIndex:0] CGPointValue];
    [path moveToPoint:firstLocation];
    
    NSArray* nodes = [self smoothPathNodes];
    NSArray* controlPoints = [self smoothPathControlPoints];
    [nodes enumerateObjectsUsingBlock:^(NSValue* node, NSUInteger idx, BOOL *stop) {
        CGPoint currNode = [[nodes objectAtIndex:idx] CGPointValue];
        if (idx == 0) {
            [path addLineToPoint:currNode];
        } else {
            CGPoint ctrlPoint = [[controlPoints objectAtIndex:idx-1] CGPointValue];
            [path addQuadCurveToPoint:currNode controlPoint:ctrlPoint];
        }
    }];
    
    CGPoint lastLocation = [[self.touches objectAtIndex:[self.touches count]-1] CGPointValue];
    [path addLineToPoint:lastLocation];

    return path;
}

static CGPoint CGPointGetCenter(CGPoint pointA, CGPoint pointB)
{
    return CGPointMake((pointA.x + pointB.x) / 2.0, (pointA.y + pointB.y) / 2.0);
}

- (NSArray *)smoothPathNodes
{
    if ([self.touches count] <= 0) {
        return nil;
    }
    
    NSMutableArray* nodes = [[NSMutableArray alloc] init];
    CGPoint prevPoint = [[self.touches objectAtIndex:0] CGPointValue];
    for (NSUInteger i=1; i<[self.touches count]; i++) {
        CGPoint currPoint = [[self.touches objectAtIndex:i] CGPointValue];
        CGPoint nodePoint = CGPointGetCenter(prevPoint, currPoint);
        [nodes addObject:[NSValue valueWithCGPoint:nodePoint]];
        prevPoint = currPoint;
    }
    
    return [NSArray arrayWithArray:nodes];
}

- (NSArray *)smoothPathControlPoints
{
    if ([self.touches count] <= 2) {
        return nil;
    }
    
    return [self.touches subarrayWithRange:NSMakeRange(1, [self.touches count]-2)];
}

@end
