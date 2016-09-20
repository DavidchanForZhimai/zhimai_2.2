//
//  WetChatPayManager.m
//  Lebao
//
//  Created by David on 16/5/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "WetChatPayManager.h"
#import "WXApi.h"
#import "ToolManager.h"
#import "XLDataService.h"

#define WetChatPay [NSString stringWithFormat:@"%@pay/index",HttpURL]
static WetChatPayManager *wetChatPayManager = nil;
static dispatch_once_t once;
@implementation WetChatPayManager
+ (instancetype)shareInstance
{
    if (!wetChatPayManager) {
        dispatch_once(&once, ^{
            
            wetChatPayManager = allocAndInit(WetChatPayManager);
            
        });
    }
    
    return wetChatPayManager;
    
}
- (void)jumpToBizPay:(NSString *)money wetChatPaySucceed:(WetChatPaySucceed)wetChatPaySucceed{
    [[ToolManager shareInstance] showWithStatus:@"微信冲值..."];
    NSDictionary *paramer = [Parameter parameterWithSessicon];
    [paramer setValue:money forKey:@"total_fee"];
    [XLDataService postWithUrl:WetChatPay param:paramer modelClass:nil responseBlock:^(id dataObj, NSError *error) {

        if (dataObj) {
           
            if ([dataObj[@"rtcode"] intValue]==1) {
                [[ToolManager shareInstance] dismiss];
                NSDictionary *dict= dataObj[@"datas"];
                [self wxPay:dict succeedMeg:@"充值成功" recharge:money wetChatPaySucceed:wetChatPaySucceed];
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus:@"服务器返回错误，未获取到json对象"];
        }
        
    }];
    
}

-(void)wxPay:(NSDictionary *)dict succeedMeg:(NSString *)msg recharge:(NSString *)recharge wetChatPaySucceed:(WetChatPaySucceed)wetChatPaySucceed 
{
    _recharge = recharge;
    _wetChatPaySucceedMsg = msg;
    _wetChatPaySucceed = wetChatPaySucceed;
    
    [WXApiManager sharedManager].delegate = self;
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}
- (void)managerDidPayResponse:(PayResp *)response
{
    [[ToolManager shareInstance] showSuccessWithStatus:_wetChatPaySucceedMsg];
    _wetChatPaySucceed(_recharge);
    
}
@end
