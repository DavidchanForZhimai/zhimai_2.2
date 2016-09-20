//
//  MoreXSCell.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MoreXSCell.h"
#import "UILabel+Extend.h"
@implementation MoreXSCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    if (self ==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *cell = allocAndInitWithFrame(UIView, frame(10, 0, cellWidth - 20, cellHeight));
        cell.backgroundColor = WhiteColor;
        [self addSubview:cell];
        
        _cellImage = allocAndInitWithFrame(UIImageView, frame(10, 10, 60, cellHeight - 20));
        [cell addSubview:_cellImage];
        
        _cellTitle = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_cellImage.frame) + 5, frameY(_cellImage), frameWidth(cell) - (CGRectGetMaxX(_cellImage.frame) + 15), 27) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _cellTitle.numberOfLines = 2;
        
        _cellStatus = [UILabel createLabelWithFrame:frame(frameX(_cellTitle), CGRectGetMaxY(_cellImage.frame) - 24*SpacedFonts , frameWidth(cell) - (CGRectGetMaxX(_cellImage.frame) + 15), 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
       [UILabel CreateLineFrame:frame(0, frameHeight(cell) - 1, frameWidth(cell), 1) inView:cell];
        
        
        
    }
    
    return self;
}

- (void)setModelWithDic:(NSDictionary *)dic
{
//    NSLog(@"dic =%@",dic);
    NSString *imageName = @"";
    if ([dic[@"industry"] isEqualToString:BAOXIAN]) {
        
        imageName  = @"jjr_baoxian";
    }
    else if ([dic[@"industry"] isEqualToString:JINRONG])
    {
        imageName  = @"jjr_jingrong";
        
    }
    else if ([dic[@"industry"] isEqualToString:FANGCHANG])
    {
        imageName  = @"jjr_fanchan";
    }
    else
    {
        imageName  = @"jjr_chehang";
    }
    _cellImage.image =[UIImage imageNamed:imageName];
    
    _cellTitle.text = dic[@"title"];
    if ([dic[@"state"] intValue]<90) {
        _cellStatus.text = @"进行中";
        _cellStatus.textColor = [UIColor colorWithRed:0.9843 green:0.4235 blue:0.1451 alpha:1.0];
    }
    else
    {
        _cellStatus.text = @"已完结";
        _cellStatus.textColor = [UIColor colorWithRed:0.4863 green:0.4863 blue:0.4941 alpha:1.0];
    }
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
