//
//  AppDelegate.m
//  Lebao
//
//  Created by David on 15/11/26.
//  Copyright © 2015年 David. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+CoreNewFeature.h"
#import "AppDelegate+WX.h"//微信
#import "AppDelegate+BDPush.h"//百度推送
#import <IQKeyboardManager.h>
#import "SYSafeCategory.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    
    //延迟进入
     [NSThread sleepForTimeInterval:1.0];
    
    //键盘统一收回处理
    [self configureBoardManager];
    
    //统一处理一些为数组、集合等对nil插入会引起闪退
    [SYSafeCategory callSafeCategory];
    
    
    
     UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
     self.window = window;
    [self.window makeKeyAndVisible];
    
    //百度推送
    [self bPushapplication:application didFinishLaunchingWithOptions:launchOptions];
    //向微信注册
    [self registerAppWithWX];
    //引导页
    [self showView];
    

    return YES;
}
#pragma mark 键盘收回管理
-(void)configureBoardManager
{
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;
//    manager.shouldResignOnTouchOutside = YES;
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
//    manager.keyboardDistanceFromTextField=0.0;
//    manager.enableAutoToolbar = NO;
}

AppDelegate* getAppDelegate(){
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
