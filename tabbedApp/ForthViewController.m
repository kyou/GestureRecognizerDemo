//
//  ForthViewController.m
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-5.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import "ForthViewController.h"
#import "CustomGestureRecognizer.h"

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
    
    CustomGestureRecognizer* customGR = [[CustomGestureRecognizer alloc] initWithTarget:self action:@selector(handleCustom:)];
    [self.view addGestureRecognizer:customGR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleCustom:(CustomGestureRecognizer *)recognizer
{
    NSLog(@"handleCheckMark!");
}

@end
