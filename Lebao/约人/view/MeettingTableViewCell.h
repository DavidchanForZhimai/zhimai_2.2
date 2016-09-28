//
//  MeettingTableViewCell.h
//  Lebao
//
//  Created by adnim on 16/9/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingCellLayout.h"

@protocol MeettingTableViewDelegate <NSObject>

@optional
//约见按钮
- (void)tableViewCellDidSeleteMeetingBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;
//对话按钮
- (void)tableViewCellDidSeleteMessageBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;
//同意和拒绝按钮
- (void)tableViewCellDidSeleteAgreeAndRefuseBtn:(UIButton *)btn layout:(MeetingCellLayout *)layout andIndexPath:(NSIndexPath *)indexPath;
////拒绝按钮
//- (void)tableViewCellDidSeleteRefuseBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;
//点击头像
- (void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen andIndexPath:(NSIndexPath *)indexPath;
@end
@interface MeettingTableViewCell : UITableViewCell
@property(nonatomic,strong)MeetingCellLayout *cellLayout;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)UIButton *meetingBtn;//约见
@property (nonatomic,strong)UIButton *messageBtn;//对话
@property (nonatomic,strong)UIButton *refuseBtn;//约见
@property (nonatomic,strong)UIButton *agreeBtn;//约见
@property(nonatomic,weak)id <MeettingTableViewDelegate > delegate;
@end
