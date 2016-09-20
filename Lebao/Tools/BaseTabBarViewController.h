//
//  BaseTabBarViewController.h
//  Lebao
//
//  Created by David on 16/4/20.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarViewController : UITabBarController

@property (strong, nonatomic) UINavigationController *discoverNav;
@property (strong, nonatomic) UINavigationController *tansboundaryNav;
@property (strong, nonatomic) UINavigationController *dynamicNav;
@property (strong, nonatomic) UINavigationController *notificationNav;
@end
