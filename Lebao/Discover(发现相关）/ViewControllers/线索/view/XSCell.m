//
//  XSCell.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/12.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "XSCell.h"

@implementation XSCell
{
    UIView * customV;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customView:frame];
    }
    return self;
}
-(void)customView:(CGRect)frame
{
    customV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-10)];
    customV.backgroundColor = [UIColor whiteColor];
    [self addSubview:customV];
    [self addTheBtnV];
    [self addTheRighgtV];
    [self addTheBlueV];
    [self addTheButtomV];
}
-(void)addTheBtnV
{
    _btnV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 61)];
    _btnV.backgroundColor = [UIColor clearColor];
    _btnV.userInteractionEnabled = YES;
    [customV addSubview:_btnV];
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 41, 41)];
    _headImg.contentMode = UIViewContentModeScaleAspectFill;
    [_btnV addSubview:_headImg];
    [customV addSubview:_btnV];

    
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_headImg.frame.origin.x+_headImg.frame.size.width+10, 7, 55, 25)];
    _userNameLab.font = [UIFont systemFontOfSize:15];
    _userNameLab.textColor = [UIColor blackColor];
    _userNameLab.textAlignment = NSTextAlignmentLeft;
    [_btnV addSubview:_userNameLab];
    
    UIImageView * posImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x, 37, 11, 11)];
    posImg.image = [UIImage imageNamed:@"dizhi"];
    [_btnV addSubview:posImg];
    
    _positionLab = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+16, 37, 49, 11)];
    _positionLab.font = [UIFont systemFontOfSize:12];
    _positionLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _positionLab.textAlignment = NSTextAlignmentLeft;
    [_btnV addSubview:_positionLab];
    
    _renzhImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+_userNameLab.frame.size.width, 13, 14, 14)];
    _renzhImg.image = [UIImage imageNamed:@"renzhen"];
    [_btnV addSubview:_renzhImg];
}
-(void)addTheRighgtV
{
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(customV.frame.size.width-160, 7, 150, 20)];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.font = [UIFont systemFontOfSize:13];
    _timeLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [customV addSubview:_timeLab];
    
    _lookLab = [[UILabel alloc]initWithFrame:CGRectMake(customV.frame.size.width-140, 31.5, 60, 20)];
    _lookLab.backgroundColor = [UIColor clearColor];
    _lookLab.font = [UIFont systemFontOfSize:12];
    _lookLab.textAlignment = NSTextAlignmentCenter;
    _lookLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    [customV addSubview:_lookLab];
    
    _commentLab = [[UILabel alloc]initWithFrame:CGRectMake(customV.frame.size.width-70, 31.5, 60, 20)];
    _commentLab.backgroundColor = [UIColor clearColor];
    _commentLab.textAlignment = NSTextAlignmentRight;
    _commentLab.font = [UIFont systemFontOfSize:12];
    _commentLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    [customV addSubview:_commentLab];
}
-(void)addTheBlueV
{
    _blueV = [[UIView alloc]initWithFrame:CGRectMake(0, 61, customV.frame.size.width, 168)];
    _blueV.backgroundColor = [UIColor colorWithRed:0.455 green:0.675 blue:0.878 alpha:1.000];
    _blueV.userInteractionEnabled = YES;
    [customV addSubview:_blueV];
    
    _hanyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hanyeBtn.frame = CGRectMake(0, 6, 45, 16);
    _hanyeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_hanyeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_hanyeBtn setBackgroundImage:[UIImage imageNamed:@"yuanxing"] forState:UIControlStateNormal];
    _hanyeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _hanyeBtn.userInteractionEnabled = NO;
    [_blueV addSubview:_hanyeBtn];
    
    
    _titLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 47, _blueV.frame.size.width, 25)];
    _titLab.backgroundColor = [UIColor clearColor];
    _titLab.textAlignment = NSTextAlignmentCenter;
    _titLab.font = [UIFont systemFontOfSize:17];
    _titLab.textColor = [UIColor whiteColor];
    [_blueV addSubview:_titLab];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 110, _blueV.frame.size.width, 1)];
    hxV.backgroundColor = [UIColor colorWithWhite:0.934 alpha:0.5000];
    [_blueV addSubview:hxV];
    
    UILabel * qwbcLab = [[UILabel alloc]initWithFrame:CGRectMake((_blueV.frame.size.width-90)/2, 100, 90, 20)];
    qwbcLab.backgroundColor = [UIColor colorWithRed:0.455 green:0.675 blue:0.878 alpha:1.000];
    qwbcLab.textAlignment = NSTextAlignmentCenter;
    qwbcLab.textColor = [UIColor colorWithRed:0.925 green:0.922 blue:0.922 alpha:1.000];
    qwbcLab.font = [UIFont systemFontOfSize:11];
    qwbcLab.text = @"成交报酬(元)";
    [_blueV addSubview:qwbcLab];
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, _blueV.frame.size.width,38)];
    _moneyLab.backgroundColor = [UIColor clearColor];
    _moneyLab.font = [UIFont boldSystemFontOfSize:24];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    _moneyLab.textColor = [UIColor whiteColor];
    [_blueV addSubview:_moneyLab];
    
}
-(void)addTheButtomV
{
    _xqqdLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 229, 130, 41)];
    _xqqdLab.backgroundColor = [UIColor clearColor];
    _xqqdLab.textAlignment = NSTextAlignmentLeft;
    _xqqdLab.font = [UIFont systemFontOfSize:13];
    [customV addSubview:_xqqdLab];
    
    _lqLab = [[UILabel alloc]initWithFrame:CGRectMake(135, 229, customV.frame.size.width-135-5, 41)];
    _lqLab.backgroundColor = [UIColor clearColor];
    _lqLab.textAlignment = NSTextAlignmentRight;
    _lqLab.font = [UIFont systemFontOfSize:13];
    [customV addSubview:_lqLab];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
