//
//  AppDelegate.h
//  Lebao
//
//  Created by David on 15/11/26.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BaseTabBarViewController *mainTab;

AppDelegate* getAppDelegate();
@end

