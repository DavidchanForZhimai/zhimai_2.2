//
//  BaseTabBarViewController.m
//  Lebao
//
//  Created by David on 16/4/20.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "DiscoverHomePageViewController.h"
#import "DynamicVC.h"
#import "NotificationViewController.h"
#import "MeetingVC.h"
@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (instancetype)init
{
    if (self =[super init]) {
        [self setNaviViewControllers];
        [self setMainTabbar];
    }
    return self;
}
#pragma mark
#pragma mark App底栏设置
- (void)setNaviViewControllers
{

    DiscoverHomePageViewController *discoverVC = [[DiscoverHomePageViewController alloc] init];
    self.discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverVC];
    
    MeetingVC *meetingVC = [[MeetingVC alloc] init];
    self.tansboundaryNav = [[UINavigationController alloc] initWithRootViewController:meetingVC];
    DynamicVC *dynamicVC = [[DynamicVC alloc] init];
    self.dynamicNav = [[UINavigationController alloc] initWithRootViewController:dynamicVC];
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    self.notificationNav = [[UINavigationController alloc] initWithRootViewController:notificationVC];
    
}
- (void)setMainTabbar
{

    self.viewControllers = [NSArray arrayWithObjects:self.tansboundaryNav,self.dynamicNav,self.notificationNav,self.discoverNav, nil];
    [self.tabBar setHidden:YES];
    
    //隐藏tabbar
    [self setSelectedIndex:0];
    CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.tabBar.frame = CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), 0);
    UIView *transitionView = [[self.view subviews] objectAtIndex:0];
    frame.size.height = CGRectGetHeight(frame);
    transitionView.frame = frame;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
