
//
//  XianSuoDetailInfo.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/26.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "XianSuoDetailInfo.h"
@interface XianSuoDetailInfo ()

@property AFHTTPRequestOperationManager *manager;

@end

@implementation XianSuoDetailInfo
+ (XianSuoDetailInfo*) shareInstance
{
    static XianSuoDetailInfo* shareInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}
- (XianSuoDetailInfo*)init
{
    self = [super init];
    
    if (self != NULL) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.requestSerializer.timeoutInterval = 15.0; // timeout for 5s;
    }
    
    return self;
}
-(void)getDetailXianSuoWithID:(NSString *)xs_id andCallBack:(xianSuoDetailCallbackType2)callBack
{
    NSString * url = [NSString stringWithFormat:@"%@demand/detail",HOST_URL];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:xs_id,@"id",userName,@"username",passWord,@"password",nil];
    
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:xs_id forKey:@"id"];
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBack(YES,nil,responseObject);
        }else
        {
            callBack(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"线索详情错误error==%@",error);
        callBack(NO,@"请检查您的网络",nil);
    }];
    
    

}
-(void)getAmountWith:(xianSuoDetailCallbackType2)callBack
{
    NSString * url = [NSString stringWithFormat:@"%@demand/getamount",HOST_URL];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"username",passWord,@"password",nil];
    
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
   [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBack(YES,nil,responseObject);
        }else
        {
            callBack(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"获取个人余额错误error==%@",error);
        callBack(NO,@"请检查您的网络",nil);
    }];

}
-(void)faBuKuaJieWithTitle:(NSString *)title andContent:(NSString *)content andIndustry:(NSString *)industry andCost:(NSString *)cost andPaytype:(NSString *)paytype audiosUrl:(NSString *)audiosUrl andCallBack:(xianSuoDetailCallbackType2)callBack
{
    NSString * url = [NSString stringWithFormat:@"%@demand/save",HOST_URL];
     NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
     [parameters setValue:title forKey:@"title"];
     [parameters setValue:industry forKey:@"industry"];
     [parameters setValue:cost forKey:@"cost"];
     [parameters setValue:paytype forKey:@"paytype"];
     [parameters setValue:content forKey:@"content"];
    if (audiosUrl) {
        [parameters setValue:audiosUrl forKey:@"audios"];
    }
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBack(YES,nil,responseObject[@"datas"]);
        }else
        {
            callBack(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"发布跨界错误error==%@",error);
        callBack(NO,@"请检查您的网络",nil);
    }];

}
-(void)lqxsWithID:(NSString *)xiansuoID andRadio:(NSString *)radio andDeposit:(NSString *)deposit andPaytype:(NSString *)paytype andCallBack:(xianSuoDetailCallbackType2)callback
{
    NSString * url = [NSString stringWithFormat:@"%@demand/receive",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setValue:radio forKey:@"radio"]; 
    [parameters setValue:xiansuoID forKey:@"id"];
    [parameters setValue:deposit forKey:@"deposit"];
    [parameters setValue:paytype forKey:@"paytype"];
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callback(YES,nil,responseObject);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"领取错误错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];

}
-(void)zfwkWithID:(NSString *)xiansuoID andFee:(NSString *)fee andPaytype:(NSString *)paytype  andCallBack:(xianSuoDetailCallbackType2)callback
{
    NSString * url = [NSString stringWithFormat:@"%@demand/pay-balance",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setValue:xiansuoID forKey:@"id"];
    [parameters setValue:fee forKey:@"fee"];
    [parameters setValue:paytype forKey:@"paytype"];
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callback(YES,nil,responseObject);
        }else
        {
            callback(NO,[responseObject objectForKey:@ "rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"领取错误错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];
    

}
-(void)xsjbWithID:(NSString *)xiansuoID andTitle:(NSString *)title andType:(NSString *)type andAuthorID:(NSString *)authorID andCallBack:(xianSuoDetailCallbackType2)callback
{
    NSString * url = [NSString stringWithFormat:@"%@demand/report",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setValue:xiansuoID forKey:@"id"];
    [parameters setValue:title forKey:@"title"];
    [parameters setValue:type forKey:@"type"];
    [parameters setValue:authorID forKey:@"authorID"];
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            
            callback(YES,nil,responseObject);
        }else
        {
            callback(NO,[responseObject objectForKey:@ "rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"领取错误错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];

}
@end
