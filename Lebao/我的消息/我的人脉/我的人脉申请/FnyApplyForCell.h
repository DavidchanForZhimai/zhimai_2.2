//
//  FnyApplyForCell.h
//  Lebao
//
//  Created by adnim on 16/11/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FnyApplyForCellLayout.h"
@protocol FnyApplyForCellDelegate <NSObject>

@optional

//取消按钮
- (void)tableViewCellDidSeleteCancelBtn:(UIButton *)btn layout:(FnyApplyForCellLayout *)layout;
//点击头像
- (void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen layout:(FnyApplyForCellLayout *)layout;

@end
@interface FnyApplyForCell : UITableViewCell
@property(nonatomic,strong)FnyApplyForCellLayout *cellLayout;
@property (nonatomic,strong)UIButton *cancelBtn;//取消
@property(nonatomic,weak)id <FnyApplyForCellDelegate > delegate;
@end
