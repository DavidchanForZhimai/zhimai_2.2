//
//  YLJViewController.h
//  Lebao
//
//  Created by David on 2016/10/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "InviteFriendsViewController.h"
@interface YLJViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)UITableView *inviteFriendsView;

@end


@interface InviteFriendsCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)dataModal:(InviteFriendsDatas *)modal isFirst:(BOOL)isFirst;
@end