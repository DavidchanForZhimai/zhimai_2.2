//
//  AppDelegate+BDPush.m
//  Lebao
//
//  Created by David on 16/7/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AppDelegate+BDPush.h"
#import "BPush.h"//推送
#import "PushManager.h"//推送管理工具类
#import "CoreArchive.h"
#define K_API_KEY @"tN6GvEjtvS7y58YG9ek0UlU6"
static BOOL isBackGroundActivateApplication;
@implementation AppDelegate (BDPush)

- (void)bPushapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    
    [BPush registerChannel:launchOptions apiKey:K_API_KEY pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    
    // 禁用地理位置推送 需要再绑定接口前调用。
    
    [BPush disableLbs];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
};

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
   
    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive) {
        
        [[PushManager shareInstace] pushData:userInfo andApplicationState:ApplicationStateActive];

    }
    //杀死状态下，直接跳转到跳转页面。
  
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
    {
       
      
         [[PushManager shareInstace] pushData:userInfo andApplicationState:ApplicationStateInactive];
        
        
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
//        NSLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        
         [[PushManager shareInstace] pushData:userInfo andApplicationState:ApplicationStateBackground];
       
    }
    
    
//    NSLog(@"%@",userInfo);
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        if (result) {
            
            // 获取channel_id
            NSString *myChannel_id = [BPush getChannelId];
            NSLog(@"myChannel_id====%@",myChannel_id);
            [CoreArchive setStr:myChannel_id key:DeviceToken];
            
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
//                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{  
//    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}



@end
