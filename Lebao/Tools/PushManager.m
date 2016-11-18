//
//  PushManager.m
//  Lebao
//
//  Created by David on 2016/11/15.
//  Copyright © 2016年 David. All rights reserved.
//
NSString * const KApiTypeMsg = @"msg"; //聊天
NSString * const KApiTypeDynamic = @"dynamic";//动态
NSString * const KApiTypeMeet = @"meet";//约见成功
//跨界线索
NSString * const KApiTypeCorps = @"corps";//我的跨界
NSString * const KApiTypeDemand = @"demand";//我的发布
NSString * const KApiTypeCoop =  @"coop";//我的发布

NSString * const KApiTypeCustom = @"custom";//客服
NSString * const KApiTypeSystem = @"system";//(约见请求、约见拒绝 、人脉添加、人脉同意、人脉拒绝、认证)（具体根据push[type]判断）
NSString * const KApiTypeSystemAuthenReject = @"authen_reject";//认证驳回
NSString * const KApiTypeSystemAuthen_pass = @"authen_pass";//认证通过

NSString * const KApiDynamicTypeLike = @"like"; //动态点赞
NSString * const KApiDynamicTypeComment = @"comment";//动态评论


NSString * const KApiSystemTypeInvitation = @"invitation";//约见请求
NSString * const KApiSystemTypeInvitationRefuse = @"invitation_refuse";//约见拒绝
NSString * const KApiSystemTypeConnectionRequest = @"connection-request";//人脉添加
NSString * const KApiSystemTypeRefuse = @"refuse";//人脉拒绝
NSString * const KApiSystemTypeConnectionAgree = @"connection-agree"; //人脉同意

#define KDynamicMsgcountURL [NSString stringWithFormat:@"%@message/count",HttpURL] //请求网络得到消息数目

#import "PushManager.h"
#import "BHBPlaySoundTool.h"//推送声音
#import "GJGCChatFriendViewController.h" //消息聊天
#import "MeetingVC.h"
#import "MyKuaJieVC.h"//我的跨界
#import "CustomerServiceViewController.h"//我的客服
#import "NotificationDetailViewController.h"//系统
#import "NotificationViewController.h"
#import "DiscoverHomePageViewController.h"
#import "XIAlertView.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import "XLDataService.h"

#import "DynamicVC.h"
#import "DynamicDetailsViewController.h"
#import "OtherDynamicdViewController.h"
#import "DyMessageViewController.h"

#import "AuthenticationHomeViewController.h"


@implementation PushDataModel

@end

@implementation PushDataApi
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"type" : @"goto",
             };
}

@end

@implementation PushDataAps

@end

@implementation PushDataChat
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end



static PushManager *pushManager;
@implementation PushManager
{
    BaseViewController * baseVC;
    PushDataModel *pushModel;
}

+  (PushManager *)shareInstace
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        pushManager =  [[self alloc]init];
        
    });
    
    return pushManager;
    
}
- (instancetype)init
{
    self = [super init];
    
    return self;
    
}
//得到消息数（动态，消息）


- (void)getMsgCountSucceed:(MsgCountSucceed)succeed
{
    //目前是重复3次请求（请求不成功情况下）
    [self getMsgCountSucceed:succeed repeat:3];
    
}
//网络请求不成功时候重复调用次数
- (void)getMsgCountSucceed:(MsgCountSucceed)succeed repeat:(int)repeat
{
    if (repeat>1) {
        
        [XLDataService postWithUrl:KDynamicMsgcountURL param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            BaseModal *model = [BaseModal mj_objectWithKeyValues:dataObj];
            //            NSLog(@"error.code=%ld dataObj =%@",error.code,dataObj);
            if (dataObj) {
                if (model.rtcode ==1) {
                    succeed([dataObj[@"dynamic_count"] intValue],[dataObj[@"message_count"]intValue]);
                }
            }
            else
            {
                if (error.code ==-1001) {
                    [self getMsgCountSucceed:succeed repeat:repeat - 1];
                }
            }
            
        }];
        
    }
    
}
//推送数据
- (void)pushData:(NSDictionary *)notifacion andApplicationState:(ApplicationState)applicationState
{
    //    NSLog(@"notifacion =%@",notifacion);
    pushModel = [PushDataModel mj_objectWithKeyValues:notifacion];
    //应用在前台的提示声音
    if (applicationState ==ApplicationStateActive) {
        [[BHBPlaySoundTool sharedPlaySoundTool] playWithSoundName:@"open"];
    }
    //设置消息未读数(动态消息未读数)
    [[PushManager shareInstace] getMsgCountSucceed:^(int dynamicCount, int msgcount) {
        
        if (dynamicCount>0) {
            [getAppDelegate().mainTab.tabBar.items objectAtIndex:1].badgeValue = [NSString stringWithFormat:@"%i",dynamicCount];
        }
        else
        {
            [getAppDelegate().mainTab.tabBar.items objectAtIndex:1].badgeValue = nil;
        }
        if (msgcount>0) {
            [getAppDelegate().mainTab.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%i",msgcount];
        }
        else
        {
            [getAppDelegate().mainTab.tabBar.items objectAtIndex:2].badgeValue = nil;
        }
        
        //应用图标数目
        [UIApplication sharedApplication].applicationIconBadgeNumber = dynamicCount + msgcount;
        
    }];
    
    //取到nav控制器当前显示的控制器
    UINavigationController * nav = (UINavigationController *)getAppDelegate().mainTab.selectedViewController;
    baseVC = (BaseViewController *)nav.visibleViewController;
    //得到当前所有控制器
    NSMutableArray *controllers  = [NSMutableArray new];
    for (UINavigationController * nav in getAppDelegate().mainTab.viewControllers) {
        for (BaseViewController *vc in nav.childViewControllers)
        {
            [controllers addObject:vc];
        }
    }
    
    //动态推送
    //    NSLog(@"pushModel.api.type =%@",pushModel.api.type);
    if ([pushModel.api.type isEqualToString:KApiTypeDynamic]) {
        if (applicationState ==ApplicationStateActive) {
            //动态详情 他人动态 动态 动态消息
            for (BaseViewController *vc in controllers) {
                if ([vc isKindOfClass:[DynamicVC class]]||[nav.childViewControllers isKindOfClass:[DyMessageViewController class]]||[nav.childViewControllers isKindOfClass:[OtherDynamicdViewController class]]||[nav.childViewControllers isKindOfClass:[DynamicDetailsViewController class]] ) {
                    [vc pushModel:pushModel.api.chat];
                }
                
            }
            
        }
        else
        {
            
            [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //动态详情 他人动态 动态 动态消息
                BOOL isVC =NO;
                for (BaseViewController *vc in controllers) {
                    if ([vc isKindOfClass:[DynamicVC class]]||[vc isKindOfClass:[DyMessageViewController class]]||[vc isKindOfClass:[DynamicDetailsViewController class]]||[vc isKindOfClass:[OtherDynamicdViewController class]] ) {
                        isVC = YES;
                        [vc pushModel:pushModel.api.chat];
                        [baseVC.navigationController popToRootViewControllerAnimated:NO];
                        [getAppDelegate().mainTab setSelectedIndex:1];
                        
                    }
                    
                }
                
                if (!isVC) {
                    [baseVC pushModel:pushModel.api.chat];
                    [baseVC.navigationController popToRootViewControllerAnimated:NO];
                    [getAppDelegate().mainTab setSelectedIndex:1];
                }
            }];
        }
        
            
       
    }
    else
    {
        //刷新消息界面
        if (applicationState ==ApplicationStateActive) {
            for (BaseViewController *vc in controllers) {
                if ([vc isKindOfClass:[NotificationViewController class]]||[vc isKindOfClass:[NotificationDetailViewController class]]) {
                    [vc pushModel:pushModel.api.chat];
                    
                }
                
            }
            
        }
        //聊天
        if ([pushModel.api.type isEqualToString:KApiTypeMsg]) {
            pushModel.api.chat.type = @"msg";
            if (applicationState ==ApplicationStateActive) {
                for (BaseViewController *vc in controllers) {
                    if ([vc isKindOfClass:[GJGCChatFriendViewController class]]) {
                        GJGCChatFriendViewController *vvc =(GJGCChatFriendViewController *)vc;
                        if ([vvc.taklInfo.toId isEqualToString:pushModel.api.bid]) {
                            [vvc reciverNotiWithData:notifacion[@"api"][@"chat"]];
                        }
                        
                    }
                    
                }
                
            }
            else {
                
                [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                    BOOL isVC =NO;
                    for (BaseViewController *vc in controllers) {
                        if ([vc isKindOfClass:[GJGCChatFriendViewController class]]) {
                            isVC = YES;
                            GJGCChatFriendViewController *vvc =(GJGCChatFriendViewController *)vc;
                            if ([vvc.taklInfo.toId isEqualToString:pushModel.api.bid]) {
                                [vvc reciverNotiWithData:notifacion[@"api"][@"chat"]];
                                
                            }
                            else
                            {
                                isVC = NO;
                            }
                            
                            
                            if ([nav.childViewControllers containsObject:vc]) {
                                [nav popToViewController:vc animated:NO];
                            }
                            else
                            {
                                [nav pushViewController:vc animated:NO];
                            }
                        }
                        
                    }
                    if (!isVC) {
                        
                        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
                        talk.talkType = GJGCChatFriendTalkTypePrivate;
                        talk.toId = pushModel.api.bid;
                        talk.toUserName = pushModel.api.chat.realname;
                        GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
                        privateChat.type = MessageTypeNormlPage;
                        [nav pushViewController:privateChat animated:YES];
                    }
                    
                }];
            }
            
        }
        //约见成功
        else if ([pushModel.api.type isEqualToString:KApiTypeMeet])
        {
            [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished){
                [[XIAlertView alloc]jueJianSucceedView:baseVC data:pushModel];
            }];
        }
        
        //系统消息
        else if ([pushModel.api.type isEqualToString:KApiTypeSystem]) {
            
            //认证成功
            if ([pushModel.api.chat.type isEqualToString:KApiTypeSystemAuthen_pass]) {
                
                if (applicationState == ApplicationStateBackground)
                {
                    [baseVC.navigationController popViewControllerAnimated:NO];
                    [getAppDelegate().mainTab setSelectedIndex:0];
                }
                
                
            }
            //认证失败
            else if ([pushModel.api.chat.type isEqualToString:KApiTypeSystemAuthenReject]) {
                
                if (applicationState ==ApplicationStateActive) {
                    //认证失败
                    if ([baseVC isKindOfClass:[AuthenticationHomeViewController class]]) {
                        [baseVC pushModel:pushModel.api.chat];
                    }
                    //弹窗
                    else
                    {
                        UIAlertView *renzenV = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:pushModel.api.chat.content delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"再去认证", nil];
                        renzenV.tag =888;
                        [renzenV show];
                    }
                    
                }
                else
                {
                    if ([baseVC.navigationController.viewControllers containsObject:(BaseViewController *)[AuthenticationHomeViewController class]]) {
                        for (BaseViewController *vc in baseVC.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[AuthenticationHomeViewController class]]) {
                                [vc pushModel:pushModel.api.chat];
                            }
                        }
                        
                    }
                    else
                    {
                        AuthenticationHomeViewController *vc = [[AuthenticationHomeViewController alloc]init];
                        [baseVC.navigationController pushViewController:vc animated:NO];
                        
                    }
                    
                }
                                
                
            }
            
            
            
        }
        
        
        //跨界
        else if ([pushModel.api.type isEqualToString:KApiTypeCorps]||[pushModel.api.type isEqualToString:KApiTypeCoop])
        {
            
            //如果是当前控制器是我的消息控制器的话，刷新数据即可
            if([baseVC isKindOfClass:[MyKuaJieVC class]])
            {
                MyKuaJieVC * myKuaJieVC = (MyKuaJieVC *)baseVC;
                if ([pushModel.api.type isEqualToString:KApiTypeCorps]) {
                    myKuaJieVC.isLinquVC = NO;
                }
                else
                {
                    myKuaJieVC.isLinquVC = YES;
                }
                
            }
            else
            {
                if (applicationState !=ApplicationStateActive) {
                    MyKuaJieVC * myKuaJieVC = allocAndInit(MyKuaJieVC);
                    if ([pushModel.api.type isEqualToString:KApiTypeDemand]) {
                        myKuaJieVC.isLinquVC = NO;
                    }
                    else
                    {
                        myKuaJieVC.isLinquVC = YES;
                    }
                    
                    [nav pushViewController:myKuaJieVC animated:YES];
                }
            }
            
        }
        else if ([pushModel.api.type isEqualToString:KApiTypeCorps])
        {
            
            if (applicationState !=ApplicationStateActive) {
                
                NotificationDetailViewController* notificationDetailViewController = allocAndInit(NotificationDetailViewController);
                
                [notificationDetailViewController pushModel:pushModel.api.chat];
                [nav pushViewController:notificationDetailViewController animated:YES];
            }
        }
        
    }
    
}
#pragma mark
#pragma mark  -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if ([baseVC.navigationController.viewControllers containsObject:(BaseViewController *)[AuthenticationHomeViewController class]]) {
            for (BaseViewController *vc in baseVC.navigationController.viewControllers) {
                if ([vc isKindOfClass:[AuthenticationHomeViewController class]]) {
                    [vc pushModel:pushModel.api.chat];
                }
            }
            
        }
        else
        {
            [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                AuthenticationHomeViewController *vc = [[AuthenticationHomeViewController alloc]init];
                [baseVC.navigationController pushViewController:vc animated:NO];
            }];
            
        }
        
    }
}
@end
