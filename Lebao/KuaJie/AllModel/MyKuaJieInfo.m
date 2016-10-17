//
//  MyKuaJieInfo.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/27.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MyKuaJieInfo.h"
#import "XLDataService.h"
@interface MyKuaJieInfo ()

@property AFHTTPRequestOperationManager *manager;

@end
@implementation MyKuaJieInfo
+ (MyKuaJieInfo*) shareInstance
{
    static MyKuaJieInfo* shareInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}
- (MyKuaJieInfo*)init
{
    self = [super init];
    if (self != NULL) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.requestSerializer.timeoutInterval = 15.0; // timeout for 5s;
    }
    
    return self;
}
-(void)getFaBuDetailXianSuoWithID:(NSString *)xs_id andCallBack:(MyKuaJieCallbackType2)callBack{
    NSString * url = [NSString stringWithFormat:@"%@demand/detail-pub",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:xs_id forKey:@"id"];
    //    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:xs_id,@"id",userName,@"username",passWord,@"password",nil];
    [[ToolManager shareInstance]showWithStatus];
    
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBack(YES,nil,responseObject);
        }else
        {
            callBack(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
    }];
}
-(void)getLinQuDetailXianSuoWithID:(NSString *)xs_id andCallBack:(MyKuaJieCallbackType2)callBack
{
    NSString * url = [NSString stringWithFormat:@"%@demand/detail-re",HOST_URL];
    
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:xs_id forKey:@"id"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBack(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callBack(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)faBuLieBiaoWithPage:(int)pageNub andCallBack:(MyKuaJieCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@demand/mypub",HOST_URL];
    //    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageNub],@"page",userName,@"username",passWord,@"password",nil];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:@(pageNub) forKey:@"page"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)lingQuLieBiaoWithPage:(int)pageNub andCallBack:(MyKuaJieCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@demand/myreceiver",HOST_URL];
    //    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageNub],@"page",userName,@"username",passWord,@"password",nil];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:@(pageNub) forKey:@"page"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
    
}
-(void)quxiaolquWithID:(NSString *)xiansuoID andCallBack:(MyKuaJieCallbackType2)callBack
{
    NSString * url = [NSString stringWithFormat:@"%@demand/cancel-demand",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:xiansuoID forKey:@"id"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBack(YES,@"取消成功",nil);
        }else
        {
            callBack(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)xuanzeHeZuoWithID:(NSString *)hezuoID andCallBack:(MyKuaJieCallbackType2)callBack
{
    NSString * url = [NSString stringWithFormat:@"%@demand/choose-coop",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:hezuoID forKey:@"id"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBack(YES,@"合作成功",nil);
        }else
        {
            callBack(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)pingJiaWithID:(NSString *)coopid andScord:(int)scord andContent:(NSString *)content andType:(int)type andCallBack:(MyKuaJieCallbackType2)callBack
{
    NSString * url ;
    if (type == 1) {
        url = [NSString stringWithFormat:@"%@demand/assess",HOST_URL];
    }else{
        url = [NSString stringWithFormat:@"%@demand/evaluate",HOST_URL];
    }
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:coopid forKey:@"id"];
    [parameters setObject:@(scord) forKey:@"scord"];
    [parameters setObject:content forKey:@"content"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBack(YES,@"评价成功",nil);
        }else
        {
            callBack(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)shensuWithID:(NSString *)coopid andContent:(NSString *)content andCallBack:(MyKuaJieCallbackType2)callBak
{
    NSString * url = [NSString stringWithFormat:@"%@demand/complain",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:coopid forKey:@"id"];
    [parameters setObject:content forKey:@"content"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBak(YES,@"申诉成功",nil);
        }else
        {
            callBak(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)buShensuWithID:(NSString *)coopid  andCallBack:(MyKuaJieCallbackType2)callBak
{
    NSString * url = [NSString stringWithFormat:@"%@demand/no-complain",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:coopid forKey:@"id"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callBak(YES,@"已选择不申诉",nil);
        }else
        {
            callBak(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)getLQRWithID:(NSString *)xsID andPage:(int)page andCallBack:(MyKuaJieCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@demand/coop-list",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:xsID forKey:@"id"];
    [parameters setObject:@(page) forKey:@"page"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)getGuanZhuLieBiaoWithPage:(int)page andCallBack:(MyKuaJieCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@broker/followlist",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:@(page) forKey:@"page"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
-(void)getFansLieBiaoWithPage:(int)page andCallBack:(MyKuaJieCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@broker/fanslist",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:@(page) forKey:@"page"];
    [[ToolManager shareInstance]showWithStatus];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
}
//通知他
-(void)getNotificationAtOtherWithId:(NSString *)userid  andDemandid:(NSString *)demandid andCallBack:(MyKuaJieCallbackType2)callback
{
    NSString * url = [NSString stringWithFormat:@"%@demand/notice",HOST_URL];
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    [parameters setObject:userid forKey:@"userid"];
    [parameters setObject:demandid forKey:@"demandid"];
    [[ToolManager shareInstance]showWithStatus:@"通知中..."];
    [XLDataService postWithUrl:url param:parameters modelClass:nil responseBlock:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    }];
    
    
}
@end
