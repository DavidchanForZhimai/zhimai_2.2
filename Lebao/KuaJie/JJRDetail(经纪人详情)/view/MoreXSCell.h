//
//  MoreXSCell.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreXSCell : UITableViewCell
@property(nonatomic,strong)UIImageView *cellImage;
@property(nonatomic,strong)UILabel     *cellTitle;
@property(nonatomic,strong)UILabel     *cellStatus;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;

- (void)setModelWithDic:(NSDictionary *)dic;
@end

