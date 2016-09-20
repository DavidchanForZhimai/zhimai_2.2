//
//  WetChatAuthenManager.h
//  Lebao
//
//  Created by David on 16/3/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^WetChatAuthenBlock)(NSString *url,NSString *openid,NSString *uid,NSString *ID,NSString *unionid);

@interface WetChatAuthenManager : NSObject
@property(nonatomic,copy)WetChatAuthenBlock succeedBlock;
@property(nonatomic,strong)NSString *shareID;
@property(nonatomic,assign)BOOL isLocalShare;
@property(nonatomic,assign)BOOL isWithdraw;//是否提现授权
@property(nonatomic,copy) NSString * withdrawMoney;//是否提现授权
@property(nonatomic,strong)NSMutableDictionary * shareparme;
//单例
+ (instancetype)shareInstance;
//是否授权成功回调
- (void)wetChatAuthen:(BOOL)isLocalShare isAuthen:(BOOL)isAuthen localshareParme:(NSMutableDictionary *)shareparme succeedBlock:(WetChatAuthenBlock)succeedBlock;
//是否提现授权
- (void)wetChatWithdrawAuthen:(BOOL)isAuthen withdrawMoney:(NSString *)withdrawMoney;

@end
