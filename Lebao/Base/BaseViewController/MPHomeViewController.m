//
//  MPHomeViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/7/1.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPHomeViewController.h"
#import "DiscoverHomePageViewController.h"
#import "DynamicVC.h"
#import "NotificationViewController.h"
#import "MeetingVC.h"
@implementation MPHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTabBarController];
        
        self.tabBar.selectedImageTintColor = AppMainColor;
        self.tabBar.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setupTabBarController {
    /// 设置TabBar属性数组
    self.tabBarItemsAttributes =[self tabBarItemsAttributesForController];
    
    /// 设置控制器数组
    self.viewControllers =[self mpViewControllers];
    
    self.delegate = self;
    self.moreNavigationController.navigationBarHidden = YES;
}


//控制器设置
- (NSArray *)mpViewControllers {
    
    MeetingVC *firstViewController = [[MeetingVC alloc] init];
    UINavigationController *firstNavigationController = [[MPBaseNavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    DynamicVC *secondViewController = [[DynamicVC alloc] init];
    UINavigationController *secondNavigationController = [[MPBaseNavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    NotificationViewController *thirdViewController = [[NotificationViewController alloc] init];
    UINavigationController *thirdNavigationController = [[MPBaseNavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    DiscoverHomePageViewController *fourthViewController = [[DiscoverHomePageViewController alloc] init];
    UINavigationController *fourthNavigationController = [[MPBaseNavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 fourthNavigationController
                                 ];
    return viewControllers;
}

//TabBar文字跟图标设置
- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"约人",
                                                 CYLTabBarItemImage : @"weixianyuejian",
                                                 CYLTabBarItemSelectedImage : @"yuejian",
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"动态",
                                                  CYLTabBarItemImage : @"weixiandongtai",
                                                  CYLTabBarItemSelectedImage : @"dongtai",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"消息",
                                                 CYLTabBarItemImage : @"icon_bar_message",
                                                 CYLTabBarItemSelectedImage : @"icon_bar_selected_message",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"发现",
                                                  CYLTabBarItemImage : @"weixianfaxian",
                                                  CYLTabBarItemSelectedImage : @"faxian"
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController*)tabBarController shouldSelectViewController:(UINavigationController*)viewController {
    /// 特殊处理 - 是否需要登录
    return YES;
}
@end
