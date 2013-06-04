//
//  AppDelegate.h
//  tabbedApp
//
//  Created by Wayne Qiao on 13-6-4.
//  Copyright (c) 2013年 Tencent Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
