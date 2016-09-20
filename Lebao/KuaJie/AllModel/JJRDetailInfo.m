//
//  JJRDetailInfo.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/26.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "JJRDetailInfo.h"
@interface JJRDetailInfo ()

@property AFHTTPRequestOperationManager *manager;

@end

@implementation JJRDetailInfo
+ (JJRDetailInfo*) shareInstance
{
    static JJRDetailInfo* shareInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}
- (JJRDetailInfo*)init
{
    self = [super init];
    
    if (self != NULL) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.requestSerializer.timeoutInterval = 15.0; // timeout for 5s;
    }
    
    return self;
}
-(void)lookForjjrWithType:(NSString *)type andPage:(int)pageNub andcityID:(int)city_ID andCallback:(JjrDetailCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@broker/agentsearch",HOST_URL];
    
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    
    if (city_ID || city_ID == 0) {
//        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageNub],@"page",userName,@"username",passWord,@"password",[NSString stringWithFormat:@"%d",city_ID],@"cityid",type,@"type",nil];
        [parameters setValue:type forKey:@"type"];
        [parameters setValue:@(city_ID) forKey:@"cityid"];
        [parameters setValue:@(pageNub) forKey:@"page"];
    
    }else{
//        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageNub],@"page",userName,@"username",passWord,@"password",type,@"type",nil];
        [parameters setValue:type forKey:@"type"];
        [parameters setValue:@(pageNub) forKey:@"page"];
    }
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
           
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"查找更多经纪人列表错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];
}
-(void)getJJRDetailWithJjrId:(NSString *)jjrID andCallBack:(JjrDetailCallbackType2)callback
{
    NSString * url = [NSString stringWithFormat:@"%@broker/agentdetail",HOST_URL];
     NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setValue:jjrID forKey:@"id"];
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
//        NSLog(@"经纪人详情错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];

}
-(void)getMoreFuwuWithID:(NSString *)jjrid andPage:(int)page andCallBack:(JjrDetailCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@broker/agentservice",HOST_URL];
    //    NSDictionary *  dic = [NSDictionary dictionaryWithObjectsAndKeys:jjrID,@"id",userName,@"username",passWord,@"password",nil];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setValue:jjrid forKey:@"id"];
    [parameters setValue:@(page) forKey:@"page"];
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"经纪人详情错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];

}
-(void)getMoreXianSuoWithID:(NSString *)jjrid andPage:(int)page andCallBack:(JjrDetailCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@broker/agentclue",HOST_URL];
    //    NSDictionary *  dic = [NSDictionary dictionaryWithObjectsAndKeys:jjrID,@"id",userName,@"username",passWord,@"password",nil];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setValue:jjrid forKey:@"id"];
    [parameters setValue:@(page) forKey:@"page"];
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"经纪人详情错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];

}
@end
