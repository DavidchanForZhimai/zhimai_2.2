//
//  MeCell.h
//  Lebao
//
//  Created by David on 15/12/7.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCell : UITableViewCell

@property(nonatomic,strong)UILabel *authen;
@property(nonatomic,strong)UILabel *message;
@property(nonatomic,strong)UILabel *detail;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;

- (void)setLeftImage:(NSString *)img  Title:(NSString *)title isShowLine:(BOOL)isShowLine;
//- (void)setLeftImage:(NSString *)img  Title:(NSString *)title rightImage:(NSString *)rightImg;
@end
