//
//  AppDelegate+WX.m
//  Lebao
//
//  Created by David on 16/7/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AppDelegate+WX.h"
#import "WXApi.h"//微信API
#import "WXApiManager.h"
@implementation AppDelegate (WX)
- (void)registerAppWithWX
{
    [WXApi registerApp:KWetChat_AppID withDescription:@"知脉"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


@end
