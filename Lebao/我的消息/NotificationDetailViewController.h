//
//  NotificationDetailViewController.h
//  Lebao
//
//  Created by David on 16/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModal.h"
typedef void(^ConnectionsRequestBlcok)();
@interface SystemMessageModal :BaseModal

@end

@interface SystemMessageData : NSObject
@property(nonatomic,copy) NSString *  createtime;
@property(nonatomic,assign) BOOL isread;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) BOOL iscoop;
@property(nonatomic,assign) BOOL isself;
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *transitions;//判断该跳转的页面
@property(nonatomic,copy) NSString *islook;//判断能否跳转页面
@property(nonatomic,copy) NSString *senderid;//senderid 为chat 时聊天对象id
@property(nonatomic,copy) NSString *senderrealname;//senderrealname 为chat 聊天对象姓名


@end

@interface NotificationDetailViewController : BaseViewController
@property(nonatomic,assign)BOOL isSystempagetype;
@property(nonatomic,copy)ConnectionsRequestBlcok succeedBlock;
@end


@interface SystemMessageCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setData:(SystemMessageData *)modal showDetial:(BOOL)showDetial;
@end
