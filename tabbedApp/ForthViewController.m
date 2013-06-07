//
//  ForthViewController.m
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-5.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import "ForthViewController.h"
#import "CustomGestureRecognizer.h"
#import "DoublePanGestureRecognizer.h"

@interface ForthViewController ()

@end

@implementation ForthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Forth", @"Forth");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
/*
    CustomGestureRecognizer* customGR = [[CustomGestureRecognizer alloc] initWithTarget:self action:@selector(handleCustom:)];
    [self.view addGestureRecognizer:customGR];
    
    UISwipeGestureRecognizer* swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.view addGestureRecognizer:swipeGR];
    [swipeGR requireGestureRecognizerToFail:customGR];
*/
    DoublePanGestureRecognizer* doublePanGR = [[DoublePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoublePan:)];
    [self.view addGestureRecognizer:doublePanGR];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleCustom:(CustomGestureRecognizer *)recognizer
{
    NSLog(@"handleCheckMark!");
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        self.centralLabel.backgroundColor = [UIColor greenColor];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"handleSwipe!");
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        self.centralLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)handleDoublePan:(CustomGestureRecognizer *)recognizer
{
    NSLog(@"handleDoublePan state:%d", recognizer.state);
}

@end
