//
//  ExhibitionIndustryCell.h
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExhibitionIndustryModel.h"
@interface ExhibitionIndustryCell : UITableViewCell
@property(nonatomic,strong)UIImageView *icon;
 - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;

- (void)setData:(ExhibitionIndustryReadmost *)model;
@end

@interface ExhibitionRedPaperCell : UITableViewCell
@property(nonatomic,strong)UIImageView *icon;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;

- (void)setData:(ExhibitionIndustryRewarddatas *)model communityBlock:(void (^)(ExhibitionIndustryRewarddatas *data))communityBlock;
@end