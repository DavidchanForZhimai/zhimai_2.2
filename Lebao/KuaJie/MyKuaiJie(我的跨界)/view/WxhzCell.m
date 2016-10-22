//
//  WxhzCell.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/24.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "WxhzCell.h"

@implementation WxhzCell
{
    UIView * customV;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customV:frame];
    }
    return self;
}
-(void)customV:(CGRect)frame
{
    customV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height-10)];
    customV.backgroundColor = [UIColor colorWithRed:0.976 green:0.973 blue:0.973 alpha:1.000];
    [self addSubview:customV];
    [self addTheNextV];
}
-(void)addTheNextV
{
    _nextV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, customV.frame.size.width, 71)];
    _nextV.userInteractionEnabled = YES;
    _nextV.backgroundColor = [UIColor whiteColor];
    [customV addSubview:_nextV];
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 41, 41)];
    [_nextV addSubview:_headImg];
    
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_headImg.frame.origin.x+_headImg.frame.size.width+10, 12, 55, 15)];
    _userNameLab.font = [UIFont systemFontOfSize:15];
    _userNameLab.textColor = [UIColor blackColor];
    _userNameLab.textAlignment = NSTextAlignmentLeft;
    [_nextV addSubview:_userNameLab];
    
    UIImageView * posImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x, 42, 11, 11)];
    posImg.image = [UIImage imageNamed:@"dizhi"];
    [_nextV addSubview:posImg];
    
    _positionLab = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+16, 42, 80, 11)];
    _positionLab.font = [UIFont systemFontOfSize:12];
    _positionLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _positionLab.textAlignment = NSTextAlignmentLeft;
    [_nextV addSubview:_positionLab];
    
    _renzhImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+_userNameLab.frame.size.width,CGRectGetMaxY(_userNameLab.frame)-[UIImage imageNamed:@"[iconprofilerenzhen]"].size.height,[UIImage imageNamed:@"[iconprofilerenzhen]"].size.width, [UIImage imageNamed:@"[iconprofilerenzhen]"].size.height)];
    _renzhImg.image = [UIImage imageNamed:@"[iconprofileweirenzhen]"];
    [_nextV addSubview:_renzhImg];
    
    UIImage *certifyimag = [UIImage imageNamed:@"[iconprofilerenzhen]"];
    _vipImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userNameLab.frame)+5, CGRectGetMaxY(_userNameLab.frame)-certifyimag.size.height, certifyimag.size.width,certifyimag.size.height)];
    _vipImg.image=certifyimag;
    [_nextV addSubview:_vipImg];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(customV.frame.size.width-160, 15, 150, 20)];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [_nextV addSubview:_timeLab];
    [self addTheGuanZhuV];
}
-(void)addTheGuanZhuV
{
    _xthzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _xthzBtn.backgroundColor = [UIColor clearColor];
    [_xthzBtn setImage:[UIImage imageNamed:@"beixuanzhong"] forState:UIControlStateNormal];
    [_xthzBtn setTitle:@"  选Ta合作" forState:UIControlStateNormal];
    [_xthzBtn setTitleColor:[UIColor colorWithRed:0.239 green:0.553 blue:0.996 alpha:1.000] forState:UIControlStateNormal];
    _xthzBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _xthzBtn.frame = CGRectMake(0, 76, customV.frame.size.width, 28);
    [customV addSubview:_xthzBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
