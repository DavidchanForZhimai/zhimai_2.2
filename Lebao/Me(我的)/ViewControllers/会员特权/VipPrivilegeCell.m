//
//  VipPrivilegeCell.m
//  Lebao
//
//  Created by adnim on 16/10/10.
//  Copyright © 2016年 David. All rights reserved.
//

#import "VipPrivilegeCell.h"

@implementation VipPrivilegeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.lab1];
        [self.contentView addSubview:self.lab2];
        [self.contentView addSubview:self.lab3];
    }
    return self;
}
-(UILabel *)lab1
{
    if (!_lab1) {
        _lab1=[[UILabel alloc]init];
        _lab1.frame=CGRectMake(10, 0, (APPWIDTH-20)/2.0, 40);
        _lab1.textAlignment=NSTextAlignmentCenter;
        _lab1.layer.borderWidth=0.5;
        _lab1.font=[UIFont systemFontOfSize:12];
        _lab1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }
    return _lab1;
}
-(UILabel *)lab2
{
    if (!_lab2) {
        _lab2=[[UILabel alloc]init];
        _lab2.frame=CGRectMake((APPWIDTH-20)/2.0+10, 0, (APPWIDTH-20)/4.0, 40);
        _lab2.textAlignment=NSTextAlignmentCenter;
        _lab2.layer.borderWidth=0.5;
        _lab2.font=[UIFont systemFontOfSize:12];
        _lab2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }
    return _lab2;
}
-(UILabel *)lab3
{
    if (!_lab3) {
        _lab3=[[UILabel alloc]init];
        _lab3.frame=CGRectMake((APPWIDTH-20)/4.0*3+10, 0, (APPWIDTH-20)/4.0, 40);
        _lab3.textAlignment=NSTextAlignmentCenter;
        _lab3.layer.borderWidth=0.5;
        _lab3.font=[UIFont systemFontOfSize:12];
        _lab3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }
    return _lab3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
