//
//  BaseTabBarViewController.h
//  Lebao
//
//  Created by David on 16/4/20.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavRootViewController.h"
@interface BaseTabBarViewController : UITabBarController
@property (strong, nonatomic) NavRootViewController *discoverNav;
@property (strong, nonatomic) NavRootViewController *tansboundaryNav;
@property (strong, nonatomic) NavRootViewController *dynamicNav;
@property (strong, nonatomic) NavRootViewController *notificationNav;
@end
