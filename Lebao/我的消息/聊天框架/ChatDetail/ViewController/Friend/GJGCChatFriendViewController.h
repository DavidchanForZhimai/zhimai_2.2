//
//  GJGCChatFriendViewController.h
//  ZYChat
//
//  Created by ZYVincent on 14-11-3.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatDetailViewController.h"
#import "GJGCChatFriendDataSourceManager.h"
typedef NS_ENUM(NSUInteger,MessageType) {
    MessageTypeNormlPage  =1,
    MeeageTypeRedPage     =2,
    MessageTypeCustomPage =3,
};
@interface GJGCChatFriendViewController : GJGCChatDetailViewController<UIActionSheetDelegate>

/* 从talkInfo中绑定更多信息给待发送内容,子类可以复写实现更多的绑定 */
- (void)setSendChatContentModelWithTalkInfo:(GJGCChatFriendContentModel *)contentModel;

/* 打电话 */
- (void)makePhoneCall:(NSString *)phoneNumber;

@property(nonatomic,assign)MessageType type;
@property(nonatomic,strong)NSString *receiver;

//接受消息
- (void)reciverNotiWithData:(NSDictionary *)dic;
@end
