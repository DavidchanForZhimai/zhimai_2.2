//
//  InviteFriendsViewController.h
//  Lebao
//
//  Created by David on 16/3/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface InviteFriendsModal : NSObject

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, copy) NSString *inviteurl;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *invitecode;

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *test;
@property (nonatomic, copy) NSString *testurl;
@end

@interface InviteFriendsDatas : NSObject

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *authen;

@end


@interface InviteFriendsViewController : BaseViewController

@end

@interface InviteFriendsCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)dataModal:(InviteFriendsDatas *)modal isFirst:(BOOL)isFirst;
@end