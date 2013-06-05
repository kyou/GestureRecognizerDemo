//
//  ThirdViewController.m
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-4.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import "ThirdViewController.h"
#import <QuartzCore/QuartzCore.h>

#define radianToDegree(x) (x/M_PI*180)

@interface ThirdViewController ()

@end

@implementation ThirdViewController
{
    UIImageView* imageView;
    CGRect originBounds;
    CGAffineTransform originTransform;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Third", @"Third");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200, 300, 300)];
    imageView.center = self.view.center;
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"mm" ofType:@"jpg"];
    imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imageView];
    originBounds = imageView.bounds;
    originTransform = imageView.transform;
    
    UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGR.delegate = self;
    [self.view addGestureRecognizer:pinchGR];
    
    UIRotationGestureRecognizer* rotationGR = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    rotationGR.delegate = self;
    [self.view addGestureRecognizer:rotationGR];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    NSLog(@"%s state:%d scale:%f", __FUNCTION__, recognizer.state, recognizer.scale);
    
    CGRect bounds = originBounds;
    bounds.size.width *= recognizer.scale;
    bounds.size.height *= recognizer.scale;
    imageView.bounds = bounds;
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        originBounds = imageView.bounds;
    }
    
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    NSLog(@"%s state:%d rotation:%f", __FUNCTION__, recognizer.state, radianToDegree(recognizer.rotation));
    
    CGAffineTransform transform = CGAffineTransformRotate(originTransform, recognizer.rotation);
    imageView.transform = transform;
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        originTransform = imageView.transform;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - @protocol UIGestureRecognizerDelegate
// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"recognizer:%@, otherRecognizer:%@", NSStringFromClass([gestureRecognizer class]), NSStringFromClass([otherGestureRecognizer class]));
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return NO;
    } else if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
