//
//  WetChatAuthenManager.m
//  Lebao
//
//  Created by David on 16/3/17.
//  Copyright © 2016年 David. All rights reserved.
//
#import "WetChatAuthenManager.h"
//工具类
#import "ToolManager.h"
#import "WXApi.h"//微信Api
#import "WXApiManager.h"//微信回调
#import "XLDataService.h"
#import "CoreArchive.h"
#define Access_token @"access_token"
#define Refresh_token @"refresh_token"

//分享到我的内容
#define SharecollectURL [NSString stringWithFormat:@"%@share/sharecollect",HttpURL]
//我的内容分享
#define WXMyreleaseshare [NSString stringWithFormat:@"%@share/index",HttpURL]
//提现接口
#define WXWithdrawURL [NSString stringWithFormat:@"%@transfer/index",HttpURL]

#define KNotificationWetChatWithdraw @"KNotificationWetChatWithdraw"
@interface WetChatAuthenManager()<WXApiManagerDelegate>
@end

static WetChatAuthenManager *wetChatAuthenManager = nil;
static dispatch_once_t once;
@implementation WetChatAuthenManager
+ (instancetype)shareInstance
{
    if (!wetChatAuthenManager) {
        dispatch_once(&once, ^{
            
            wetChatAuthenManager = allocAndInit(WetChatAuthenManager);
            
        });
    }
    
    return wetChatAuthenManager;
    
}
//分享授权接口
- (void)wetChatAuthen:(BOOL)isLocalShare isAuthen:(BOOL)isAuthen localshareParme:(NSMutableDictionary *)shareparme succeedBlock:(WetChatAuthenBlock)succeedBlock
{
     _isWithdraw = NO;
    
    _isLocalShare = isLocalShare;
    _shareparme = shareparme;
    
    if (![WXApi isWXAppInstalled]) {
        
        [[ToolManager shareInstance] showInfoWithStatus:@"未安装微信"];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        
        [[ToolManager shareInstance] showInfoWithStatus:@"此版本不支持微信分享"];
        return;
    }

    
    _succeedBlock = succeedBlock;
    
    if (isAuthen) {
        if ([CoreArchive strForKey:Access_token]) {
        
                [self refreshAccess_token];
        }
        else
        {
                 [self wetChatAuthen];
        }
    }
    else
    {
        [self postUserInfo:nil isAuthen:isAuthen];
    }
    

}
//是否提现授权
- (void)wetChatWithdrawAuthen:(BOOL)isAuthen withdrawMoney:(NSString *)withdrawMoney
{
    _isWithdraw = YES;
    _withdrawMoney = withdrawMoney;
    if (isAuthen) {
       [self wetChatAuthen];
    }
    else
    {
       [self postUserInfo:nil isAuthen:isAuthen];
    }
}
#pragma mark
#pragma mark 授权
- (void)wetChatAuthen
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    //回调
    [WXApiManager sharedManager].delegate =self;
}
#pragma mark
#pragma mark 回调
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{

    if (response.code) {
        [self getAccess_token:response.code];
    }
    
}
#pragma mark
#pragma mark 带上code获取token
-( void )getAccess_token:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",KWetChat_AppID,KWetChat_AppSecret,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dic[@"errcode"] intValue] ==40029) {
                    
                    [self refreshAccess_token];
                    
                }
                else
                {
                    [CoreArchive setStr:dic[@"access_token"] key:Access_token];
                    [CoreArchive setStr:dic[@"refresh_token"] key:Refresh_token];
                    [self getUserInfo:dic[@"access_token"] openid:dic[@"openid"]];
                }
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
               
            }
        });
    });
}

#pragma mark
#pragma mark -根据第二步获取的token和openid获取用户的相关信息。
-( void )refreshAccess_token{
    
    [[ToolManager shareInstance] showWithStatus];
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",KWetChat_AppID,[CoreArchive strForKey:Refresh_token]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //invalid refresh_token
                if ([dic[@"errcode"] intValue] ==40030) {
                    [self wetChatAuthen];
                    [[ToolManager shareInstance]dismiss];
                }
                else
                {
                    [CoreArchive setStr:dic[@"access_token"] key:Access_token];
                    [CoreArchive setStr:dic[@"refresh_token"] key:Refresh_token];
                    [self getUserInfo:dic[@"access_token"] openid:dic[@"openid"]];
                }
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
                
            }
        });
    });

}


#pragma mark
#pragma mark -根据第二步获取的token和openid获取用户的相关信息。
-( void )getUserInfo:(NSString *)access_token openid:(NSString *)openid
{
    NSString *url =[NSString stringWithFormat:@ "https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=zh_CN" ,access_token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                    [self postUserInfo:dic isAuthen:YES];
                
                
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
            
            }
        });
    });
    
}
#pragma mark
#pragma mark -根据获取用户的相关信息发送到自己的服务器上。
- (void)postUserInfo:(NSDictionary *)dic isAuthen:(BOOL)isAuthen
{
//    NSLog(@"dic =%@",dic);
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    if (isAuthen) {
        if (dic[@"openid"]) {
            [param setObject:dic[@"openid"] forKey:@"openid"];
        }
        if (dic[@"nickname"]) {
            [param setObject:dic[@"nickname"] forKey:@"nickname"];
        }
        if (dic[@"sex"]) {
            [param setObject:dic[@"sex"] forKey:@"sex"];
        }
        if (dic[@"language"]) {
            [param setObject:dic[@"language"] forKey:@"language"];
        }
        if (dic[@"city"]) {
            [param setObject:dic[@"city"] forKey:@"city"];
        }
        if (dic[@"province"]) {
            [param setObject:dic[@"province"] forKey:@"province"];
        }
        if (dic[@"country"]) {
            [param setObject:dic[@"country"] forKey:@"country"];
        }
        if (dic[@"headimgurl"]) {
            [param setObject:dic[@"headimgurl"] forKey:@"headimgurl"];
        }
        if (dic[@"unionid"]) {
            [param setObject:dic[@"unionid"] forKey:@"unionid"];
        }

    }
    //提现
    if (_isWithdraw) {
       
        [param setValue:_withdrawMoney forKey:@"amount"];
        [[ToolManager shareInstance] showWithStatus:@"提现..."];
        [XLDataService postWithUrl:WXWithdrawURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            NSLog(@"dataObj =%@",dataObj);
            if (dataObj) {
                
                if ([dataObj[@"rtcode"] integerValue] ==1) {
                    [[ToolManager shareInstance]showSuccessWithStatus:@"提现成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationWetChatWithdraw object:_withdrawMoney];
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                }
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
            }
            
        }];
       
    }
    //分享
    else
    {
   [param setObject:_shareID forKey:@"acid"];
    NSString *urlStr =WXMyreleaseshare;
    if (_isLocalShare) {
        urlStr = SharecollectURL;
        for (NSString *key in _shareparme.allKeys) {
            [param setValue:_shareparme[key] forKey:key];
            
        }
    }
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:urlStr param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        [self dataObj:dataObj isLocalShare:_isLocalShare];
    }];
    }
   
}
//分享
- (void)dataObj:(NSDictionary *)dataObj isLocalShare:(BOOL)isLocalShare
{
    if (dataObj) {
        
        if ([dataObj[@"rtcode"] intValue]==1) {
            if (_succeedBlock) {
               
            _succeedBlock(dataObj[@"url"],dataObj[@"openid"],dataObj[@"uid"],dataObj[@"id"],dataObj[@"unionid"]);
                
            }
            
            [[ToolManager shareInstance]dismiss];
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
        }
        
    }
    else
    {
        [[ToolManager shareInstance] showInfoWithStatus];
    }

}
@end
