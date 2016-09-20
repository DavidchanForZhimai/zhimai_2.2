//
//  FabuCell.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/18.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "FabuCell.h"

@implementation FabuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _timeLab.layer.cornerRadius = 6.0f;
    _timeLab.layer.masksToBounds = YES;
    _hanyeBtn.layer.cornerRadius = 4.0f;
    _xuqiuBtn.layer.cornerRadius = 4.0f;
    _allinV.userInteractionEnabled = YES;
    [_mySlider setThumbImage:[UIImage imageNamed:@"yixiangsu"] forState:UIControlStateNormal];
    [self autoArrangrBoxWithConstraints:@[_shheOrgx,_hzzOrgx,_sddjOrgx,_sdwkOrgx,_ypjOrgx] width:13];
    [super updateConstraints];
}
-(void)autoArrangrBoxWithConstraints:(NSArray *)constrain width:(CGFloat)width
{
    CGFloat step = ((SCREEN_WIDTH-80)-(width * (constrain.count +2)))/(constrain.count +1);
    for (int i = 0; i < constrain.count ; i ++) {
        NSLayoutConstraint * constr = constrain[i];
        constr.constant = step ;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
