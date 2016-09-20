//
//  MoreFWCell.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "MoreFWCell.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"
#import "ToolManager.h"
@implementation MoreFWCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *cell = allocAndInitWithFrame(UIView, frame(10, 0, cellWidth - 20, cellHeight));
        cell.backgroundColor = WhiteColor;
        [self addSubview:cell];
        
        _cellImage = allocAndInitWithFrame(UIImageView, frame(10, 10, 60, cellHeight - 20));
        [cell addSubview:_cellImage];
        
        _cellTitle = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_cellImage.frame) + 5, frameY(_cellImage), frameWidth(cell) - (CGRectGetMaxX(_cellImage.frame) + 15), 27) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _cellTitle.numberOfLines = 2;
        
        _cellTime = [UILabel createLabelWithFrame:frame(frameX(_cellTitle), CGRectGetMaxY(_cellImage.frame) - 24*SpacedFonts , frameWidth(cell) - (CGRectGetMaxX(_cellImage.frame) + 15), 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
     
        [UILabel CreateLineFrame:frame(0, frameHeight(cell) - 1, frameWidth(cell), 1) inView:cell];
    }
    
    return self;
}

- (void)setModelWithDic:(NSDictionary *)dic
{
    [[ToolManager shareInstance] imageView:_cellImage setImageWithURL:dic[@"imgurl"] placeholderType:PlaceholderTypeImageProcessing];
    _cellTitle.text = dic[@"title"];
    NSString *time = dic[@"createdate"];
    _cellTime.text = [time timeformatString:@"yyyy-MM-dd"];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
