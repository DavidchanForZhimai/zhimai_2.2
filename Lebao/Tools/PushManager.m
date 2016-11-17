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

NSString * const KApiDynamicTypeLike = @"like"; //动态点赞
NSString * const KApiDynamicTypeComment = @"comment";//动态评论


NSString * const KApiSystemTypeInvitation = @"invitation";//约见请求
NSString * const KApiSystemTypeInvitationRefuse = @"invitation_refuse";//约见拒绝
NSString * const KApiSystemTypeConnectionRequest = @"connection-request";//人脉添加
NSString * const KApiSystemTypeRefuse = @"refuse";//人脉拒绝
NSString * const KApiSystemTypeConnectionAgree = @"connection-agree"; //人脉同意


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

@end

@implementation PushDataChatPush

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end


static PushManager *pushManager;
@implementation PushManager

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
    succeed(2,3);
}
//推送数据
- (void)pushData:(NSDictionary *)notifacion andApplicationState:(ApplicationState)applicationState
{
    NSLog(@"notifacion =%@",notifacion);
    PushDataModel *pushModel = [PushDataModel mj_objectWithKeyValues:notifacion];
    //应用在前台的提示声音
    if (applicationState ==ApplicationStateActive) {
        [[BHBPlaySoundTool sharedPlaySoundTool] playWithSoundName:@"open"];
    }
    //设置消息未读数(动态消息未读数)
    [self getMsgCountSucceed:^(int dynamicCount, int msgcount) {
        
        [getAppDelegate().mainTab.tabBar.items objectAtIndex:1].badgeValue = [NSString stringWithFormat:@"%i",dynamicCount];
        [getAppDelegate().mainTab.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%i",msgcount];
        //应用图标数目
       [UIApplication sharedApplication].applicationIconBadgeNumber = dynamicCount + msgcount;
        
    }];
   
    //取到nav控制器当前显示的控制器
    UINavigationController * nav = (UINavigationController *)getAppDelegate().mainTab.selectedViewController;
    UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    
    //刷新界面
    if ([baseVC isKindOfClass:[NotificationViewController class]] ) {
        
        NotificationViewController *noti = (NotificationViewController *)baseVC;
        noti.isRefresh = YES;
        
    }
    //返回刷新
    for (UIViewController *subVC in nav.viewControllers) {
        if ([subVC isKindOfClass:[NotificationViewController class]]) {
            NotificationViewController *noti = (NotificationViewController *)subVC;
            noti.isRefresh = YES;
        }
        
    }
    
    if ([pushModel.api.type isEqualToString:KApiTypeMsg]) {
        
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[GJGCChatFriendViewController class]])
        {
            GJGCChatFriendViewController *comm =(GJGCChatFriendViewController*)baseVC;
            if ([pushModel.api.bid intValue]==[comm.taklInfo.toId intValue]) {
                
                [comm reciverNotiWithData:notifacion[@"api"][@"chat"]];
            }
            else
            {
                if (applicationState !=ApplicationStateActive) {
                    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
                    talk.talkType = GJGCChatFriendTalkTypePrivate;
                    talk.toId = pushModel.api.bid;
                    talk.toUserName = pushModel.api.chat.realname;
                    
                    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
                    privateChat.type = MessageTypeNormlPage;
                    [comm.navigationController pushViewController:privateChat animated:YES];
                }
                
                
            }
            return;
        }
        // 否则，跳转到我的消息
        if (applicationState !=ApplicationStateActive) {
            [[ToolManager shareInstance].drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
                talk.talkType = GJGCChatFriendTalkTypePrivate;
                talk.toId = pushModel.api.bid;
                talk.toUserName = pushModel.api.chat.realname;
                
                GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
                privateChat.type = MessageTypeNormlPage;
                [nav pushViewController:privateChat animated:YES];
            }];
            
        }
        
    }
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
    else if ([pushModel.api.type isEqualToString:KApiTypeCorps]||[pushModel.api.type isEqualToString:KApiTypeSystem])
    {
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[NotificationDetailViewController class]])
        {
            NotificationDetailViewController* notificationDetailViewController = (NotificationDetailViewController *)baseVC;
            if ([pushModel.api.type isEqualToString:KApiTypeCorps]) {
                notificationDetailViewController.isSystempagetype = NO;
            }
            else
            {
                notificationDetailViewController.isSystempagetype = YES;
            }
            
        }
        else
        {
            if (applicationState !=ApplicationStateActive) {
                
                NotificationDetailViewController* notificationDetailViewController = allocAndInit(NotificationDetailViewController);
                
                if ([pushModel.api.type isEqualToString:KApiTypeCorps]) {
                    notificationDetailViewController.isSystempagetype = NO;
                }
                else
                {
                    notificationDetailViewController.isSystempagetype = YES;
                }
                
                [nav pushViewController:notificationDetailViewController animated:YES];
            }
        }
        
        
    }
    else if ([pushModel.api.type isEqualToString:KApiTypeCustom])
    {
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[CustomerServiceViewController class]])
        {
            CustomerServiceViewController* customerServiceViewController = (CustomerServiceViewController *)baseVC;
            customerServiceViewController.isRefresh = YES;
        }
        else
        {
            if (applicationState !=ApplicationStateActive) {
                
                CustomerServiceViewController* customerServiceViewController = allocAndInit(CustomerServiceViewController);
                
                [nav pushViewController:customerServiceViewController animated:YES];
            }
        }
        
        
    }
    else if ([pushModel.api.type isEqualToString:KApiTypeMeet])
    {
        
        [[XIAlertView alloc]jueJianSucceedView:baseVC data:pushModel];
    }
    else
    {
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[MeetingVC class]])
        {
            
            
        }
        else
        {
            [[ToolManager shareInstance] LoginmianView];
        }
        
        
    }

}
@end
