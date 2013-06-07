//
//  FirstViewController.m
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-4.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import "FirstViewController.h"
#import "GestureTraceView.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
{
    GestureTraceView* traceView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
        traceView_ = [[GestureTraceView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:traceView_];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer* panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"handlePan! state:%d", recognizer.state);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [traceView_.touches removeAllObjects];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [recognizer locationInView:traceView_];
        NSValue* locationVal = [NSValue valueWithCGPoint:location];
        [traceView_.touches addObject:locationVal];
        [traceView_ setNeedsDisplay];
    }
}

@end
