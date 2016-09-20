//
//  MyCrossBroderView.h
//  Lebao
//
//  Created by David on 16/4/6.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseButton.h"
#import "UILabel+Extend.h"
@class MyCrossBroderRelease,MyCrossBroderRewardforwards,MyCrossBroderCell;

typedef void (^MoneyBlock)(NSString *rewardreleasesum,NSString *rewardforwardsum);
typedef void (^DidCellBlock)(MyCrossBroderRelease *myCrossBroderRelease,MyCrossBroderRewardforwards*myCrossBroderRewardforwards,MyCrossBroderCell *cell);
typedef void (^CommunityBlock)(MyCrossBroderRewardforwards*myCrossBroderRewardforwards,MyCrossBroderRelease *myCrossBroderRelease);


@interface MyCrossBroderModal : NSObject

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, copy) NSString *rewardforwardsum;

@property (nonatomic, strong) NSArray<MyCrossBroderRewardforwards *>*rewardforwards;

@property (nonatomic, copy) NSString *rewardreleasesum;

@property (nonatomic, assign) NSInteger release_page;

@property (nonatomic, strong) NSArray<MyCrossBroderRelease *> *myCrossBroderRelease;

@property (nonatomic, copy) NSString *rtmsg;

@property (nonatomic, assign) NSInteger release_allpage;

@property (nonatomic, copy) NSString *reward_count;

@property (nonatomic, copy) NSString *release_count;

@property (nonatomic, copy) NSString *reward_page;

@property (nonatomic, assign) NSInteger reward_allpage;

@property (nonatomic, assign) NSInteger rtcode;


@end

@interface MyCrossBroderRelease : NSObject

@property (nonatomic, copy) NSString *comsum;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, assign) NSInteger verify;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *reward_article;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *actype;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, assign) NSInteger createtime;

@property (nonatomic, assign) NSInteger rewardreadsum;

@property (nonatomic, assign) NSInteger rewardforwardcount;

@end

@interface MyCrossBroderRewardforwards : NSObject

@property (nonatomic, assign) NSInteger readcount;

@property (nonatomic, assign) NSInteger acid;

@property (nonatomic, copy) NSString *industry;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, assign) NSInteger createtime;

@property (nonatomic, copy) NSString *comsum;

@property (nonatomic, assign) NSInteger ratio;

@property (nonatomic, copy) NSString *reward_article;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) float reward;

@property (nonatomic, copy) NSString *actype;

@property (nonatomic, assign)BOOL isgetclue;
@end

@interface MyCrossBroderView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    int rewardPage;
    int rewardNowPage;
    
    int releasePage;
    int releasepNowPage;
}
@property(nonatomic,assign)int selectedIndex;
@property(nonatomic,copy)MoneyBlock moneyBlock;
@property(nonatomic,copy)DidCellBlock didCellBlock;
@property(nonatomic,copy)CommunityBlock communityBlock;
@property(nonatomic,strong)UITableView *crossBroderView;
@property(nonatomic,strong)NSMutableArray *myCrossBroderArray;

- (instancetype)initWithFrame:(CGRect)frame  selectedIndex:(int)selectedIndex moneyBlock:(MoneyBlock)moneyBlock didCellBlock:(DidCellBlock)didCellBlock communityBlock:(CommunityBlock)communityBlock;
@end


@interface  MyCrossBroderCell: UITableViewCell
@property(nonatomic,strong)UIImageView *cellIcon;
@property(nonatomic,strong)DWLable *celltitle;
@property(nonatomic,strong) BaseButton* redPaper;
@property(nonatomic,strong) BaseButton* communicationsBtn;
@property(nonatomic,strong) BaseButton* time;
@property(nonatomic,strong) BaseButton* eyes;
@property(nonatomic,strong) BaseButton* percent;
@property(nonatomic,strong) BaseButton* money;
@property(nonatomic,strong) BaseButton* share;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellheight cellWidth:(float)cellWidth;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeights:(float)cellheight cellWidths:(float)cellWidth;

- (void)setRewardforwards:(MyCrossBroderRewardforwards *)modal communityBlock:(CommunityBlock)communityBlock;
- (void)setRelease:(MyCrossBroderRelease *)modal communityBlock:(CommunityBlock)communityBlock;
@end

