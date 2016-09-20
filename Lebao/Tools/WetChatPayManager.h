//
//  WetChatPayManager.h
//  Lebao
//
//  Created by David on 16/5/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiManager.h"
typedef void (^WetChatPaySucceed)(NSString *payMoney);
@interface WetChatPayManager : NSObject<WXApiManagerDelegate>
//单例
+ (instancetype)shareInstance;
@property(nonatomic,copy) NSString* wetChatPaySucceedMsg;
@property(nonatomic,copy) NSString* recharge;
@property(nonatomic,copy) WetChatPaySucceed wetChatPaySucceed;
- (void)jumpToBizPay:(NSString *)money wetChatPaySucceed:(WetChatPaySucceed)wetChatPaySucceed;
-(void)wxPay:(NSDictionary *)dict succeedMeg:(NSString *)msg recharge:(NSString *)recharge wetChatPaySucceed:(WetChatPaySucceed)wetChatPaySucceed ;
@end
