//
//  HeadLineOneCell.m
//  Lebao
//
//  Created by adnim on 16/10/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "HeadLineOneCell.h"

@implementation HeadLineOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.bgImgView];
        [self.contentView addSubview:self.labBgView];
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}
-(UIView *)bgView
{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        _bgView.frame=CGRectMake(10, 0, APPWIDTH-20, (APPWIDTH-20)/9.0*5+10);
        _bgView.backgroundColor=[UIColor whiteColor];
        
    }
    return _bgView;
}

-(UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView=[[UIImageView alloc]init];
        _bgImgView.frame=CGRectMake(20, 10, APPWIDTH-40, (APPWIDTH-40)/9.0*5);
    }
    return _bgImgView;
}
-(UIView *)labBgView
{
    if (!_labBgView) {
        _labBgView=[[UIView alloc]init];
        _labBgView.frame=CGRectMake(20, _bgImgView.height-20, APPWIDTH-40, 30);
        _labBgView.backgroundColor=[UIColor lightGrayColor];
        _labBgView.alpha=0.3;
    }
    return _labBgView;
}
-(UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.frame=_labBgView.frame;
        _titleLab.textAlignment=NSTextAlignmentCenter;
        _titleLab.font=[UIFont systemFontOfSize:16];
        _titleLab.textColor=[UIColor whiteColor];
        _titleLab.numberOfLines=0;
    }
    return _titleLab;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
