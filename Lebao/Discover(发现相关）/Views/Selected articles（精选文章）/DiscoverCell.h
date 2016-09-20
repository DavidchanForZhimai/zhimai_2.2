//
//  DiscoverCell.h
//  Lebao
//
//  Created by David on 15/12/7.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverModel.h"
//发现轮播图
#import "WHC_Banner.h"
@interface DiscoverCell : UITableViewCell

@property(nonatomic,strong) UIImageView *icon;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setModel:(DiscoverDataModel *)model;
@end


@interface DiscoverFirstCell : UITableViewCell
@property(nonatomic,strong) WHC_Banner *banner;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth datas:(NSMutableArray *)datas;
@end


//@interface DiscoverSecondCell : UITableViewCell
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
//@end