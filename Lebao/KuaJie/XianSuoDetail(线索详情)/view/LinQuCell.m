//
//  LinQuCell.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/17.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "LinQuCell.h"

@implementation LinQuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customV:frame];
    }
    return self;
}
-(void)customV:(CGRect)frame
{
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 41, 41)];
    _headImg.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_headImg];
    
    
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_headImg.frame.origin.x+_headImg.frame.size.width+10, 7, 55, 25)];
    _userNameLab.font = [UIFont systemFontOfSize:15];
    _userNameLab.textColor = [UIColor blackColor];
    _userNameLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_userNameLab];
    
    _dingjLab = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x, 37, 90, 11)];
    _dingjLab.font = [UIFont systemFontOfSize:12];
    _dingjLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _dingjLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_dingjLab];
    
    _renzhImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+_userNameLab.frame.size.width, 13, 14, 14)];
    _renzhImg.image = [UIImage imageNamed:@"renzhen"];
    [self addSubview:_renzhImg];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-160, 7, 150, 25)];
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textColor = [UIColor colorWithWhite:0.678 alpha:1.000];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLab];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(2, frame.size.height-1, frame.size.width-4, 1)];
    hxV.backgroundColor = [UIColor colorWithRed:0.827 green:0.831 blue:0.831 alpha:1.000];
    [self addSubview:hxV];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
