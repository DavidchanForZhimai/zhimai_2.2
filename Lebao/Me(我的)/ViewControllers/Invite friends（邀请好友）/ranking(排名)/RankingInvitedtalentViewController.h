//
//  RankingInvitedtalentViewController.h
//  Lebao
//
//  Created by David on 16/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"


@class RankingActivity;
@interface RankingInvitedtalentModal : NSObject
@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, strong) NSArray<RankingActivity *> *activity;

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, copy) NSString *surplus;

@property (nonatomic, copy) NSString *aclink;

@end


@interface RankingActivity : NSObject

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, assign) NSInteger money;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, assign) NSInteger ranking;

@end


typedef void (^ActGetURlBlock)(NSString *url);
@interface RankingInvitedtalentViewController : BaseViewController
@property(nonatomic,copy)ActGetURlBlock geturlBlock;
@end


@interface RankingInvitedtalentView : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight cellWidth:(CGFloat)cellWidth;
@property(nonatomic,strong)UILabel *ranking;
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *individual;
@property(nonatomic,strong)UILabel *authen;
@property(nonatomic,strong)UILabel *jiangjin;

- (void)setmodal:(RankingActivity *)data;
@end



