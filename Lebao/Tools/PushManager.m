//
//  PushManager.m
//  Lebao
//
//  Created by David on 2016/11/15.
//  Copyright © 2016年 David. All rights reserved.
//

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

//推送数据
- (void)pushData:(NSDictionary *)notifacion andApplicationState:(ApplicationState)applicationState
{
    NSLog(@"notifacion =%@",notifacion);
    //应用在前台的提示声音
    if (applicationState ==ApplicationStateActive) {
        [[BHBPlaySoundTool sharedPlaySoundTool] playWithSoundName:@"open"];
    }
    
    UINavigationController * nav = (UINavigationController *)getAppDelegate().mainTab.selectedViewController;
    
    //取到nav控制器当前显示的控制器
    UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    //当前四大tab之一
    for (UIViewController *view in nav.viewControllers) {
        //        NSLog(@"view =%@",view);
        if ([NSStringFromClass([view class]) isEqualToString:@"DiscoverHomePageViewController"]||[NSStringFromClass([view class]) isEqualToString:@"DynamicVC"]||[NSStringFromClass([view class]) isEqualToString:@"NotificationViewController"]||[NSStringFromClass([view class]) isEqualToString:@"MeetingVC"]) {
            BaseViewController *baseView = (BaseViewController *)view;
            [baseView pushMessage];
        }
    }
    
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
    
    if ([notifacion[@"api"][@"goto"] isEqualToString:@"msg"]) {
        
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[GJGCChatFriendViewController class]])
        {
            GJGCChatFriendViewController *comm =(GJGCChatFriendViewController*)baseVC;
            if ([notifacion[@"api"][@"bid"] intValue]==[comm.taklInfo.toId intValue]) {
                
                [comm reciverNotiWithData:notifacion[@"api"][@"chat"]];
            }
            else
            {
                if (applicationState !=ApplicationStateActive) {
                    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
                    talk.talkType = GJGCChatFriendTalkTypePrivate;
                    talk.toId = notifacion[@"api"][@"bid"];
                    talk.toUserName = notifacion[@"api"][@"chat"][@"realname"];
                    
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
                talk.toId = notifacion[@"api"][@"bid"];
                talk.toUserName = notifacion[@"api"][@"chat"][@"realname"];
                
                GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
                privateChat.type = MessageTypeNormlPage;
                [nav pushViewController:privateChat animated:YES];
            }];
            
        }
        
    }
    else if ([notifacion[@"api"][@"goto"] isEqualToString:@"demand"]||[notifacion[@"api"][@"goto"] isEqualToString:@"coop"])
    {
        
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[MyKuaJieVC class]])
        {
            MyKuaJieVC * myKuaJieVC = (MyKuaJieVC *)baseVC;
            if ([notifacion[@"api"][@"goto"] isEqualToString:@"demand"]) {
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
                if ([notifacion[@"api"][@"goto"] isEqualToString:@"demand"]) {
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
    else if ([notifacion[@"api"][@"goto"] isEqualToString:@"corps"]||[notifacion[@"api"][@"goto"] isEqualToString:@"system"])
    {
        //如果是当前控制器是我的消息控制器的话，刷新数据即可
        if([baseVC isKindOfClass:[NotificationDetailViewController class]])
        {
            NotificationDetailViewController* notificationDetailViewController = (NotificationDetailViewController *)baseVC;
            if ([notifacion[@"api"][@"goto"] isEqualToString:@"corps"]) {
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
                
                if ([notifacion[@"api"][@"goto"] isEqualToString:@"corps"]) {
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
    else if ([notifacion[@"api"][@"goto"] isEqualToString:@"custom"])
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
    else if ([notifacion[@"api"][@"goto"] isEqualToString:@"meet"])
    {
        
        [[XIAlertView alloc]jueJianSucceedView:nav data:notifacion];
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
