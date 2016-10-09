//
//  HeadLineTwoCell.m
//  Lebao
//
//  Created by adnim on 16/10/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "HeadLineTwoCell.h"

@implementation HeadLineTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.TitleLab];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}
-(UIView *)bgView
{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        _bgView.frame=CGRectMake(10, 0, APPWIDTH-20, 70);
        _bgView.backgroundColor=[UIColor whiteColor];
    }
    return _bgView;
}
-(UILabel *)TitleLab
{
    if (!_TitleLab) {
        _TitleLab=[[UILabel alloc]init];
        _TitleLab.frame=CGRectMake(20, 10,APPWIDTH-100, 50);
        _TitleLab.font=[UIFont systemFontOfSize:15];
        _TitleLab.lineBreakMode=NSLineBreakByCharWrapping;
        _TitleLab.numberOfLines=0;
    }
    return _TitleLab;
}
-(UIImageView *)imgView
{
    if (!_imgView) {
        _imgView=[[UIImageView alloc]init];
        _imgView.frame=CGRectMake(APPWIDTH-70, 10, 50, 50);
    }
    return _imgView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
