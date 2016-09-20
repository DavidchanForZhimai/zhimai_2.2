//
//  AppDelegate+BDPush.h
//  Lebao
//
//  Created by David on 16/7/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (BDPush)<UIAlertViewDelegate>

- (void)bPushapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
