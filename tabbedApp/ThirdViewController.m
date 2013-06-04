//
//  ThirdViewController.m
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-4.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import "ThirdViewController.h"

#define radianToDegree(x) (x/M_PI*180)

@interface ThirdViewController ()

@end

@implementation ThirdViewController
{
    UIImageView* imageView;
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
//    imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imageView];
    
    UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGR];
    
    UIRotationGestureRecognizer* rotationGR = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self.view addGestureRecognizer:rotationGR];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    NSLog(@"%s state:%d scale:%f", __FUNCTION__, recognizer.state, recognizer.scale);
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    NSLog(@"%s state:%d rotation:%f", __FUNCTION__, recognizer.state, radianToDegree(recognizer.rotation));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
